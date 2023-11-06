variable "region" {
  type        = string
  description = "The AWS region where the resources will be created."
  default = "us-east-1"
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where the EKS cluster and related resources will be deployed."
  default = "vpc-0eaac7dbfa87419c1"
}

variable "subnet1_cidr" {
  type        = list(string)
  description = "A list of CIDR blocks for the subnets in the EKS cluster."
  default = [ "192.168.0.0/24", "192.168.1.0/24" ]
}

variable "subnet2_cidr" {
  type        = list(string)
  description = "A list of CIDR blocks for the subnets in the EKS cluster."
  default = [ "192.168.2.0/24", "192.168.3.0/24" ]
}

variable "subnet_AZ" {
  type        = list(string)
  description = "A list of availability zones for the subnets in the EKS cluster."
  default = [ "us-east-1a", "us-east-1b" ]
}

variable "instance_types" {
  type        = string
  description = "The instance type to use for the EKS worker nodes."
  default = "t2.micro"
}

variable "desired_size" {
  type        = number
  description = "The desired number of worker nodes in the EKS cluster."
  default = 3
}

variable "max_size" {
  type        = number
  description = "The maximum number of worker nodes in the EKS cluster."
  default = 4
}

variable "min_size" {
  type        = number
  description = "The minimum number of worker nodes in the EKS cluster."
  default = 3
  
}