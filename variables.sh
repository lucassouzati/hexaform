#!/bin/bash

# Diretório onde o arquivo values.yaml está localizado
directory="hexacluster"

# Caminho completo para o arquivo values.yaml
values_file="${directory}/values.yaml"

# Obter o valor da saída "db_connection_string" e "account_id" usando Terraform
db_connection_string=$(terraform output -json | jq -r '.db_connection_string.value')
account_id=$(terraform output -json | jq -r '.account_id.value')
db_password_hexafood_pagamento=$(terraform output -json | jq -r '.db_password_hexafood_pagamento.value')
db_host_hexafood_pagamento=$(terraform output -json | jq -r '.db_host_hexafood_pagamento.value' | cut -d':' -f1)
db_username_hexafood_pagamento=$(terraform output -json | jq -r '.db_username_hexafood_pagamento.value')
db_database_hexafood_pagamento=$(terraform output -json | jq -r '.db_database_hexafood_pagamento.value')

# Obter as credenciais AWS do arquivo ~/.aws/credentials usando awk
aws_credentials_file="$HOME/.aws/credentials"
aws_access_key_id=$(cut -d'=' -f2- <<<"$(grep aws_access_key_id $aws_credentials_file)" | xargs)
aws_secret_access_key=$(cut -d'=' -f2- <<<"$(grep aws_secret_access_key $aws_credentials_file)" | xargs)
aws_session_token=$(cut -d'=' -f2- <<<"$(grep aws_session_token $aws_credentials_file)" | xargs)
aws_default_region="us-east-1" # Defina sua região padrão aqui


# Verificar se as saídas não estão vazias
if [ -n "$db_connection_string" ] && [ -n "$account_id" ]; then
    # Atualizar o arquivo values.yaml com o novo valor usando yq
    yq e ".database.connectionStringPostgresPedido = \"$db_connection_string\"" -i "$values_file"
    yq e ".account.id = \"$account_id\"" -i "$values_file"

    yq e ".database.db_password_hexafood_pagamento = \"$db_password_hexafood_pagamento\"" -i "$values_file"
    yq e ".database.db_host_hexafood_pagamento = \"$db_host_hexafood_pagamento\"" -i "$values_file"
    yq e ".database.db_username_hexafood_pagamento = \"$db_username_hexafood_pagamento\"" -i "$values_file"
    yq e ".database.db_database_hexafood_pagamento = \"$db_database_hexafood_pagamento\"" -i "$values_file"


    
    # Atualizar credenciais AWS no values.yaml usando yq
    yq e ".account.AWS_ACCESS_KEY_ID = \"$aws_access_key_id\"" -i "$values_file"
    yq e ".account.AWS_SECRET_ACCESS_KEY = \"$aws_secret_access_key\"" -i "$values_file"
    yq e ".account.AWS_SESSION_TOKEN = \"$aws_session_token\"" -i "$values_file"
    yq e ".account.AWS_DEFAULT_REGION = \"$aws_default_region\"" -i "$values_file"

    echo "Valores atualizados em ${values_file}"
else
    echo "Erro: Não foi possível obter o valor da saída 'db_connection_string' ou 'account_id'."
fi


# # Diretório onde o arquivo values.yaml está localizado
# directory="hexacluster"

# # Caminho completo para o arquivo values.yaml
# values_file="${directory}/values.yaml"

# # Obter o valor da saída "db_connection_string"
# db_connection_string=$(terraform output -json | jq -r '.db_connection_string.value')
# account_id=$(terraform output -json | jq -r '.account_id.value')

# # Verificar se as saídas não estão vazias
# if [ -n "$db_connection_string" ] && [ -n "$account_id" ]; then
#     # Atualizar o arquivo values.yaml com o novo valor do DB_CONNECTION_STRING
    # yq e ".database.connectionString = \"$db_connection_string\"" -i "$values_file"
    # yq e ".account.id = \"$account_id\"" -i "$values_file"

#     echo "Valores de 'db_connection_string' e 'account_id' atualizados em ${values_file}"
# else
#     echo "Erro: Não foi possível obter o valor da saída 'db_connection_string' ou 'account_id'."
# fi
