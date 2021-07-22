data "aws_subnet_ids" "vpc_private_subnets" {
  vpc_id = var.vpc_id
  tags = {
    Scope = "private"
  }
}

data "aws_subnet_ids" "vpc_public_subnets" {
  vpc_id = var.vpc_id
  tags = {
    Scope = "public"
  }
}

module "eks" {
  source          = "./eks"
  name            = var.name
  environment     = var.environment
  region          = var.region
  vpc_id          = var.vpc_id
  private_subnets = data.aws_subnet_ids.vpc_private_subnets
  public_subnets  = data.aws_subnet_ids.vpc_public_subnets
  kubeconfig_path = var.kubeconfig_path
}

module "ingress" {
  source       = "./ingress"
  name         = var.name
  environment  = var.environment
  region       = var.region
  vpc_id       = var.vpc_id
  cluster_name = module.eks.cluster_name
}
