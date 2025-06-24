terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.95.0, < 6.0.0"
    }
    local = {
      source  = "hashicorp/local"
    }
    null = {   # is needed to trigger scripts without creating infrastructure
      source  = "hashicorp/null"
    }
    cloudinit = { # used for installing packages or setting up the environment at launch time
      source  = "hashicorp/cloudinit"
    }

    docker = {
      source  = "kreuzwerker/docker"
      version = "3.6.1"
    }

  }
}