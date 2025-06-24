# This Terraform configuration file sets up a VPC, subnets, and necessary networking components for EKS cluster deployment.
# It uses the Terraform AWS provider and the VPC module to create a network environment suitable for running an EKS cluster.
# It also includes data sources to dynamically fetch availability zones and local variables for better maintainability.
# The configuration is modular and reusable, allowing for easy adjustments to the VPC and subnet settings
# as needed for different environments or requirements.

# Provider block for AWS 
provider "aws" {
  region = var.aws_region
}


# Data source to fetch available AWS availability zones
# This is useful for dynamically determining the zones to use in the EKS cluster
# and for other resources that may require availability zones.
data "aws_availability_zones" "available" {
  state = "available"
}

# Locals are used to store temporary values that can be reused throughout the configuration.
# Here, we define a local variable for the cluster name.  
# Helpful for maintaining consistency and avoiding hardcoding the cluster name in multiple places.

locals {
    cluster_name = "eks-cluster"
}


# VPC configuration
# This block creates a new VPC with the specified CIDR block.
module "vpc" { 
  source  = "terraform-aws-modules/vpc/aws" # This module creates VPC, subnets, RT, IGW, NAT gw, Elastic IP for NAT, RT associations
  version = "~> 5.0" # Use the latest version of the VPC module

  name                 = "eks-vpc"
  cidr                 = var.vpc_cidr
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true

  # Tags are used to determine which subnets to use for Load Balancers && What type of Load Balancer to associate with those subnets (public vs private)
  tags = { 
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"   
  }
  # Without these tags:
    # Kubernetes won’t know which subnet to use when it provisions an ELB.
    # ServiceType: LoadBalancer might fail to create the right resources in the right place.
    # Load balancers may end up misconfigured or in the wrong subnet tier.

public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared" # This tag indicates that the subnet is shared with the EKS cluster
    "kubernetes.io/role/elb" = "1" # This tag indicates that the subnet is intended for ELB (Elastic Load Balancer) usage
}

private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared" # This tag indicates that the subnet is shared with the EKS cluster
    "kubernetes.io/role/internal-elb" = "1" # This tag indicates that the subnet is intended for internal ELB usage
}
}