<h1 align="center">
    Hexaform
</h1>


## Índice

- <a href="#boat-sobre-o-projeto">Sobre o projeto</a>
- <a href="#hammer-tecnologias">Tecnologias</a>
- <a href="#rocket-como-rodar-esse-projeto">Como rodar esse projeto</a>
- <a href="#world_map-composição-do-terraform">Composição do Terraform</a>
- <a href="#globe_with_meridians-infraestrutura-na-aws">Infraestrutura na AWS</a>
- <a href="#globe_with_meridians-comunicação-assíncrona-entre-microsserviços">Comunicação assíncrona entre microsserviços</a>
- <a href="#chart_with_upwards_trend-melhorias">Melhorias</a>
- <a href="#bookmark_tabs-licença">Licença</a>
- <a href="#wink-autores">Autores</a>

## :boat: Sobre o projeto

Esse projeto faz parte do trabalho "Tech Challenge - Fase 05", ministrado no quinto módulo do curso de Pós Graduação Software Architecture da FIAP em parceria com a Alura.

Para exercitar os conceitos apresentados nas matérias do curso, sendo elas SAGA Pattern, Desenvolvimento Seguro e Privacidade de Dados e Lei Geral de Proteção de Dados (LGPD), esse projeto foi atualizado a fim de abarcar os novos conteúdos. Dessa forma, cada microsservico do projeto foi alterado para implementar novas práticas aprendidas no módulo. Nesse repositório está o microsserviço de Pedidos. 

Toda infraestrutura e microsserviços estão distribuídos pelos seguintes repositórios:

- [Hexaform (Infraestrutura)](https://github.com/lucassouzati/hexaform) (Este)
- [Microsserviço Pedido](https://github.com/Hexafood-Corporation/hexafood-pedido) 
- [Microsserviço Produção](https://github.com/Hexafood-Corporation/hexafood-producao/)
- [Microsserviço Pagamento](https://github.com/Hexafood-Corporation/hexafood-payments)

## :hammer: Tecnologias:

- **[Terraform](https://www.terraform.io/)**
- **[Kubernetes](https://kubernetes.io/pt-br/)**
- **[Helm](https://helm.sh/)**
- **[EKS](https://aws.amazon.com/pt/eks/)**

## :rocket: Como rodar esse projeto

Considerando que você já possui AWS CLI, Terraform, Kubectl e Helm já instalados na sua máquina e configurados corretamente na sua conta AWS, basta clonar o repositório, acessar o diretório e executar:

```
terraform init
```

Neste momento, será criado um plano de execução e você poderá ver tudos recursos que serão alocados na AWS. Para executar o provisionamento: 

```
terraform apply -auto-approve
```

Este processo demorará alguns minutos. 

Esse projeto foi implementado no console da AWS Academy, onde tem-se uma série de restrições como impossibilidade de fazer alterações no IAM Service. Também é restrito a criação de provedores para conexões de OpenID, recurso necessário para instâncias de serviços da AWS se autenticarem por IAM Roles em vez de secrets. Dessa forma, foi necessário realizar algumas adaptações como passagem de variáveis e secrets de ambiente diretamente nos arquivos yaml do Helm. Para isso, basta executar o comando:
```
./variables.sh
```

Por último, basta fazer o deploy do cluster com o comando:
```
helm upgrade --install hexacluster ./hexacluster
```

Dessa forma, o cluster estará executando na sua instância do EKS provisionada. 

## :world_map: Composição do Terraform

O Terraform é uma ferramenta de software de infraestrutura como código criada pela HashiCorp. Os usuários definem e fornecem infraestrutura de data center usando uma linguagem de configuração declarativa conhecida como HashiCorp Configuration Language.

Dando continuidade a estrutura construída na fase anterior com EKS para provisão do cluster kubernetes, RDS para banco de dados e System Manager Store para cadastro de variáveis de ambiente e secrets, API Gateway e Lambda Function para autenticação das requisições, foi realizado a adição de novos recursos.

Como houve a quebra do monolito em três microsserviços, foi acrescentando o SQS (Simple Queue Service) para implementação da comunicação assíncronas entre os microsserviços. Além disso, foi acrescentado o ECR (Elastic Container Registry) para armazenamento das imagens dos containers de cada microsserviço.

Para atendimento de um requisitos do Tech Challenge, foi implementado um banco NoSQL para operação dos microsserviços, sendo escolhido o DynamoDB por facilidade de portabiliadde na AWS.

Dessa forma, o desenho da estrutura modular do Terraform atualizado fica da seguinte forma:
<br>
<h4 align="center">
    <img alt="Representação visual do Terraform" title="estruturacao-terraform" src=".github/readme/estruturacao-terraform2.drawio.png" width="1864px" />
</h4>
<br>

## :globe_with_meridians: Infraestrutura na AWS

Foi atualizado o desenho da arquitetura da infraestrutura na AWS, a fim de evidenciar a separação dos microsserviços:
<br>
<h4 align="center">
    <img alt="Arquitetura na AWS" title="arquitetura-aws" src=".github/readme/arquitetura-aws2.drawio.png" width="1864px" />
</h4>
<br>
Cada microsserviço passou a ser um deployment no cluster Kubernetes no EKS, com 2 réplicas e com seu próprio load balancer expondo as portas de acesso. A pipeline faz o deploy dos artefatos gerados (imagens docker) no ECR, sendo o EKS atualizar os pods para novas versões de imagem geradas no registry. Também é válido ressaltar que cada microsserviço tem o seu próprio banco de dados, garantindo assim independência total entre eles. 

O API Gateway adquire uma nova responsabilidade agora que é fazer o mapeamento de todos endpoints e redirecionar para o microsserviço correto. Dessa forma previne-se um acoplamento de um cenário onde por exemplo, um microsserviço precisar comunicar com outro, ele não precisar quem é o outro microsserviço. Dessa forma, nossa estrutura torna-se intercambiável.

## :globe_with_meridians: Comunicação assíncrona entre microsserviços

Para obter-se o ganho máximo de uma arquitetura de microsserviços, deve-se garantir sempre quando possível, a assincronidade na comunicação entre os componentes da arquitetura. Dessa forma, se um microsserviço precisa comunicar algum evento a outro, ele não pode depender de uma comunicação síncrona para isso, pois dessa forma criaríamos um forte acoplamento entre ambos, prejudicando a escabilidade do ecossistema. 

Por isso, os microsserviços foram configurados a se comunicarem através de eventos, onde a comunicação se dá majoriatriamente por filas SQS, conforme fluxo desenhado na figura a seguir:

<br>
<h4 align="center">
    <img alt="Arquitetura na AWS" title="arquitetura-aws" src=".github/readme/hexafood-orquestrado.png" width="1864px" />
</h4>
<br>

Detalhando o diagrama, o microsserviço "pedido" continua como centralizador da regra de negócio, pois ele é o responsável por receber o pedido do cliente e também por avisar ao cliente que o pedido está pronto. O fluxo então funciona da seguinte forma:

1. Microsserviço pedido dispara o evento para fila "novo pedido";
2. Microsserviço pagamento escuta a fila "novo pedido", processa o pagamento e dispara outro evento pra fila "pagamento processado";
3. O microsserviço pedido escuta a fila "pagamento processado", e o pagamento sendo aceito, ele dispara outro evento pra fila "pedido recebido";
4. O microsserviço produção escuta a fila "pedido recebido" e os coloca na fila de produção
5. Quanto o pedido é finalizado, o micro servico produção deve disparar um evento "pedido finalizado""
6. O microsserviço atualiza o "pedido finalizado" através da fila e comunica ao cliente, encerrando assim o fluxo. 

## :chart_with_upwards_trend: Melhorias

Durante a implementação deste projeto, foi constatado oportunidades de melhorias que poderão vir a ser implementadas futuramente. Dentre elas pode-se destacar:

- Implementação de ferramentas de observalidade
- Adoção de estratégias de deploy como Deploy Blue-Green ou Canary
- Refatorações diversas nos workflows a fim de mitigar pontos de falha
- Implementação de gerenciador de secretos no Kubernetes

## :bookmark_tabs: Licença

Este projeto esta sobe a licença MIT. Veja a [LICENÇA](https://opensource.org/licenses/MIT) para saber mais.

## :wink: Autores

Feito com ❤️ por:

- [Bruno Padilha](https://www.linkedin.com/in/brpadilha/)
- [Lucas Siqueira](https://www.linkedin.com/in/lucassouzatidev/)
- [Marayza Gonzaga](https://www.linkedin.com/in/marayza-gonzaga-7766251b1/)

[Voltar ao topo](#índice)

