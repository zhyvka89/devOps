terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

# Модулі будуть підключені на наступних кроках
module "s3_backend" {
  source = "./modules/s3-backend"

  bucket_name          = "lesson-5-terraform-state-julia-387867038969"
  dynamodb_table_name  = "lesson-5-terraform-locks"
}
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr = "10.0.0.0/16"

  public_subnets_cidr = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24"
  ]

  private_subnets_cidr = [
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24"
  ]

  availability_zones = [
    "eu-central-1a",
    "eu-central-1b",
    "eu-central-1c"
  ]
}
# module "ecr" {}
