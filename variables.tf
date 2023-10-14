variable "cluster_name" {
  default = "k8s-demo"
}

variable "region" {
  default = "us-east-1"
}

variable "kubernetes_version" {
  default = "1.19"
}

variable "nodes_instances_sizes" {
  default = [
    "t1.micro"
  ]
}

variable "auto_scale_options" {
  default = {
    min     = 2
    max     = 4
    desired = 2
  }
}

variable "auto_scale_cpu" {
  default = {
    scale_up_threshold  = 80
    scale_up_period     = 60
    scale_up_evaluation = 2
    scale_up_cooldown   = 300
    scale_up_add        = 2

    scale_down_threshold  = 40
    scale_down_period     = 120
    scale_down_evaluation = 2
    scale_down_cooldown   = 300
    scale_down_remove     = -1
  }
}