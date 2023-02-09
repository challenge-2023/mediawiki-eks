data aws_vpc "eks_vpc"{
  #filter {
  #  name = join("-", [var.cust_id, "vpc"])
  tags = {
    Name = join("-", [var.cust_id, "vpc"])
  }
}

data aws_subnets "eks_subnets"{
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.eks_vpc.id]
  }

}
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = join("-", [var.cust_id, "eks"])
  cluster_version = var.eks_version

  cluster_endpoint_public_access  = true
  create_iam_role	= true
  enable_irsa = false
  #create_kms_key	= false
  create_cloudwatch_log_group	= false
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = data.aws_vpc.eks_vpc.id
  subnet_ids               = data.aws_subnets.eks_subnets.ids

  # Self Managed Node Group(s)
 # self_managed_node_group_defaults = {
 #   instance_type                          = "t3.medium"
 #   update_launch_template_default_version = true
 #   iam_role_additional_policies = {
 #     AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
 #   }
 # }

#  self_managed_node_groups = {
#    one = {
#      name         = "ng1"
#      max_size     = 2
#      desired_size = 2

#      use_mixed_instances_policy = false

#      }
#    }


    # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["t3.medium"]
  }

  eks_managed_node_groups = {
    ng2 = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"
    }
  }
  }
