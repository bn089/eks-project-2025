variable aws_region {
  description = "The AWS region to deploy the EKS cluster in."
  type        = string
  default     = "us-east-1"
}

variable vpc_cidr {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable kubernetes_version {
  description = "The Kubernetes version to use for the EKS cluster."
  type        = string
  default     = "1.31"
}