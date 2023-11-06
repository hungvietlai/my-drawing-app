module "eks_cluster" {
    source = "./module/eks"
    region = var.region
    vpc_id = var.vpc_id
    subnet1_cidr = var.subnet1_cidr
    subnet2_cidr = var.subnet2_cidr
    subnet_AZ = var.subnet_AZ
    instance_types = var.instance_types
    desired_size = var.desired_size
    max_size = var.max_size
    min_size = var.min_size

}