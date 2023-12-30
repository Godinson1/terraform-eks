provider "kubernetes" {
    host = data.aws_eks_cluster.app-cluster.endpoint
    token = data.aws_eks_cluster_auth.app-cluster.token
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.app-cluster.certificate_authority.0.data)
}

data "aws_eks_cluster" "app-cluster" {
    name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "app-cluster" {
    name = module.eks.cluster_id
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.21.0"

  cluster_name    = "${var.app_name}-cluster"
  cluster_version = "1.27"

  vpc_id  = module.app-vpc.vpc_id
  subnet_ids = module.app-vpc.private_subnets

  tags = {
    environment = var.env_prefix
    application = var.app_name
  }

  eks_managed_node_groups = {
    blue = {}
    green = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = [var.instance_type_one, var.instance_type_two]
    }
  }
}