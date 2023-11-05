#!/bin/bash

# Parando a execução do script em caso de erro
set -e

# Definindo variáveis de ambiente necessárias
export TF_CLOUD_ORGANIZATION="hexafood"
# export TF_API_TOKEN="your_terraform_api_token_here" # Substitua pelo seu token real
export TF_WORKSPACE="hexaform"
export AWS_REGION="us-east-1"
export CLUSTER_NAME="hexaform"

# Gera arquivo terraform.tfvars com as variáveis de configuração
# echo "TF_CLOUD_ORGANIZATION=$TF_CLOUD_ORGANIZATION" > terraform.tfvars
# echo "TF_API_TOKEN=$TF_API_TOKEN" >> terraform.tfvars

# Inicializa o Terraform
terraform init

# Obtem o output do Terraform
export ROLE_ARN=$(terraform output -raw pod_service_account_role_arn)
if [ -z "$ROLE_ARN" ]; then
  echo "ROLE_ARN is empty. Check Terraform outputs."
  exit 1
fi

# Configura o kubeconfig para o EKS
aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME

# Instala e atualiza os charts do Helm
helm repo add secrets-store-csi-driver https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts
helm upgrade --install -n kube-system csi-secrets-store secrets-store-csi-driver/secrets-store-csi-driver
kubectl apply -f https://raw.githubusercontent.com/aws/secrets-store-csi-driver-provider-aws/main/deployment/aws-provider-installer.yaml
helm upgrade --install -n kube-system --set syncSecret.enabled=true csi-secrets-store secrets-store-csi-driver/secrets-store-csi-driver
helm template ./hexacluster
helm upgrade --install hexacluster ./hexacluster --set serviceAccount.annotations.eks.role_arn=$ROLE_ARN

echo "Provisionamento realizado com sucesso."
