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

  bucket_name          = "lesson-8-9-terraform-state-julia-387867038969"
  dynamodb_table_name  = "lesson-8-9-terraform-locks"
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
module "ecr" {
  source = "./modules/ecr"

  repository_name = "django-app"
}

module "eks" {
  source = "./modules/eks"

  cluster_name = "lesson-8-9-eks"

  vpc_id = module.vpc.vpc_id

  subnet_ids = module.vpc.private_subnets_ids

  private_subnet_ids = module.vpc.private_subnets_ids
}

module "jenkins" {
  source = "./modules/jenkins"
  cluster_name = module.eks.cluster_name
  cluster_endpoint = module.eks.cluster_endpoint
  cluster_ca       = module.eks.cluster_ca

  kubeconfig = "C:/Users/Comp100/.kube/config"

  oidc_provider_arn = module.eks.oidc_provider_arn

  oidc_provider_url = module.eks.oidc_provider_url

}

module "argo_cd" {
  source       = "./modules/argo_cd"
  namespace    = "argocd"
  chart_version = "5.46.4"

  cluster_name     = module.eks.cluster_name
  cluster_endpoint = module.eks.cluster_endpoint
  cluster_ca       = module.eks.cluster_ca
}

module "rds" {
  source = "./modules/rds"

  name            = "app-db"
  use_aurora      = true

  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets

  db_name         = "app"
  username        = "admin"
  password        = "password123"

  engine          = "aurora-postgresql"
  engine_version  = "13.7"
  instance_class  = "db.t3.medium"
}
