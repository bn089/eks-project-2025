module "eks" {
    source = "terraform-aws-modules/eks/aws"
    version         = "20.37.1"

    cluster_name    = local.cluster_name
    cluster_version = var.kubernetes_version

    subnet_ids = module.vpc.private_subnets # Use private subnets for the EKS cluster
    vpc_id     = module.vpc.vpc_id # The VPC ID where the EKS cluster will be created

    cluster_endpoint_public_access = true

    tags = {
        Environment = "dev"
        Terraform   = "true" # Tags are useful for identifying resources created by Terraform
    }

eks_managed_node_group_defaults = { # defines default values that apply to all managed node groups you create inside eks_managed_node_groups &&  use this to avoid repeating the same values for every node group &&  basically a "global default config" for managed node groups
    ami_type               = "AL2_x86_64" # using Amazon Linux 2 for your worker nodes (the default EKS AMI type) but this one is not supported by K8s 1.33 version so make sure versions support 
    instance_types         = ["t3.medium"] # instances will be t3.medium (2 vCPU, 4GB RAM)
    vpc_security_group_ids = [aws_security_group.allow_tls.id]
  }

  eks_managed_node_groups = { # defines the actual managed node groups that will be created && You can have multiple node groups under this block && Each one can override any default values if needed
    node_group = { # Creating a managed node group called node_group
      min_size     = 2 # always at least 2 nodes
      max_size     = 6 # can scale up to 6 nodes
      desired_size = 2  # 2 nodes at creation time 
    }
  }
}