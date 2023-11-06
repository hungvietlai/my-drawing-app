variable "region" {
  type        = string
  description = "The AWS region where the resources will be created."
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where the EKS cluster and related resources will be deployed."
}

variable "subnet1_cidr" {
  type        = list(string)
  description = "A list of CIDR blocks for the subnets1 in the EKS cluster."
}

variable "subnet2_cidr" {
  type        = list(string)
  description = "A list of CIDR blocks for the subnets2 in the EKS cluster."
}

variable "subnet_AZ" {
  type        = list(string)
  description = "A list of availability zones for the subnets in the EKS cluster."
}

variable "instance_types" {
  type        = string
  description = "The instance type to use for the EKS worker nodes."
}

variable "desired_size" {
  type        = number
  description = "The desired number of worker nodes in the EKS cluster."
}

variable "max_size" {
  type        = number
  description = "The maximum number of worker nodes in the EKS cluster."
}

variable "min_size" {
  type        = number
  description = "The minimum number of worker nodes in the EKS cluster."

}
