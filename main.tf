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
  enable_irsa = true
  #create_aws_auth_configmap = true
  #manage_aws_auth_configmap = true
  aws_auth_node_iam_role_arns_non_windows = ["arn:aws:iam::210489297222:role/eksnode"]
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
    aws-ebs-csi-driver = {
      most_recent = true
    }
  }

  vpc_id                   = data.aws_vpc.eks_vpc.id
  subnet_ids               = data.aws_subnets.eks_subnets.ids


    # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["t3.medium"]
  }

  eks_managed_node_groups = {
    ng2 = {
      min_size     = 2
      max_size     = 3
      desired_size = 2
      iam_role_additional_policies = {
        AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        }
      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"
    }
  }
  }

resource "aws_iam_policy" "eks-elb" {
  # ... other configuration ...
  name = "AWSLoadBalancerControllerIAMPolicy"
  policy = "${file("iam_policy.json")}"
}