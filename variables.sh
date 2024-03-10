#!/bin/bash

# Diretório onde o arquivo values.yaml está localizado
directory="hexacluster"

# Caminho completo para o arquivo values.yaml
values_file="${directory}/values.yaml"

# Obter o valor da saída "db_connection_string"
db_connection_string=$(terraform output -json | jq -r '.db_connection_string.value')
account_id=$(terraform output -json | jq -r '.account_id.value')

# Verificar se as saídas não estão vazias
if [ -n "$db_connection_string" ] && [ -n "$account_id" ]; then
    # Atualizar o arquivo values.yaml com o novo valor do DB_CONNECTION_STRING
    yq e ".database.connectionString = \"$db_connection_string\"" -i "$values_file"
    yq e ".account.id = \"$account_id\"" -i "$values_file"

    echo "Valores de 'db_connection_string' e 'account_id' atualizados em ${values_file}"
else
    echo "Erro: Não foi possível obter o valor da saída 'db_connection_string' ou 'account_id'."
fi
