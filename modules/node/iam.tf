# resource "aws_iam_role" "eks_node_role" {
#   name = format("%s-node-role", var.cluster_name)

#   assume_role_policy = jsonencode({
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Principal = {
#         Service = "ec2.amazonaws.com"
#       }
#     }]
#     Version = "2012-10-17"
#   })

# }

# resource "aws_iam_role_policy_attachment" "eks_AmazonEKSWorkerNodePolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#   role       = aws_iam_role.eks_node_role.name
# }

# resource "aws_iam_role_policy_attachment" "eks_AmazonEKS_CNI_Policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#   role       = aws_iam_role.eks_node_role.name
# }

# resource "aws_iam_role_policy_attachment" "eks_AmazonEC2ContainerRegistryReadOnly" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#   role       = aws_iam_role.eks_node_role.name
# }

# data "aws_caller_identity" "current" {}

# resource "aws_iam_policy" "eks_node_ssm_access" {
#   name        = format("%s-node-role", var.cluster_name)
#   description = "Permite que os nodes do EKS acessem parâmetros específicos no SSM Parameter Store"

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Action   = ["ssm:GetParameter", "ssm:GetParameters", "ssm:DescribeParameters"],
#         Resource = "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter${var.parameter_prefix}/*"
#         Effect   = "Allow"
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "eks_nodes_ssm" {
#   policy_arn = aws_iam_policy.eks_node_ssm_access.arn
#   role       = aws_iam_role.eks_node_role.name
# }



# data "http" "eks_oidc" {
#   url = "${var.issuer}/.well-known/openid-configuration"
#   //"https://oidc.eks.${var.region}.amazonaws.com/id/${data.aws_caller_identity.current.issuer}/.well-known/openid-configuration"
# }

# # data "http" "eks_oidc_cert" {
# #   url = jsondecode(data.http.eks_oidc.body).jwks_uri
# # }

# data "tls_certificate" "eks_oidc" {
#   url = jsondecode(data.http.eks_oidc.body).jwks_uri
# }


# resource "aws_iam_openid_connect_provider" "eks_oidc" {
#   url                   = var.eks_url
#   client_id_list        = ["sts.amazonaws.com"]
#   thumbprint_list       = [data.tls_certificate.eks_oidc.certificates[0].sha1_fingerprint]
# }

# resource "aws_iam_role" "pod_service_account_role" {
#   name = "pod-service-account-role"
  
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Principal = {
#           Federated = aws_iam_openid_connect_provider.eks_oidc.arn
#         },
#         Action = "sts:AssumeRoleWithWebIdentity",
#         Condition = {
#           "StringEquals" : {
#             "${aws_iam_openid_connect_provider.eks_oidc.url}:sub": "system:serviceaccount:default:hexaform"
#           }
#         }
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "pod_service_account_role_ssm" {
#   policy_arn = aws_iam_policy.eks_node_ssm_access.arn
#   role       = aws_iam_role.pod_service_account_role.name
# }

# resource "aws_iam_policy" "secrets_manager_access" {
#   name        = "${var.cluster_name}-secrets-manager-access"
#   description = "Permite acesso ao AWS Secrets Manager"

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Action = [
#           "secretsmanager:GetSecretValue",
#           "secretsmanager:DescribeSecret",
#           "secretsmanager:ListSecretVersionIds",
#           "ssm:DescribeParameters",
#           "ssm:GetParameter",
#           "ssm:GetParameters",
#           "ssm:GetParametersByPath"
#         ],
#         Resource = "*"  # Substitua pelo ARN específico se você deseja restringir a política para segredos específicos
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "pod_service_account_role_secrets_manager" {
#   policy_arn = aws_iam_policy.secrets_manager_access.arn
#   role       = aws_iam_role.pod_service_account_role.name
# }
