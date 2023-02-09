variable "AWS_ACCESS_KEY" {}

variable "AWS_SECRET_KEY" {}

variable "cust_id" {
  default = "abc"
}

variable "cidr_block" {
  default = "10.100.0.0/16"
}

variable "private_subnets" {
  default =  ["10.100.1.0/24", "10.100.2.0/24"]
}

variable "public_subnets" {
  default =    ["10.100.101.0/24", "10.100.102.0/24"]
}

variable "azs" {
  default =    ["us-west-2a", "us-west-2b"]

}

variable "region" {
  default = "us-west-2"
}

variable "eks_version" {
  default = "1.24"
}

