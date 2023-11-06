provider "aws" {
  region = var.region
}

data "aws_vpc" "existing_vpc" {
  id = var.vpc_id
}

resource "aws_internet_gateway" "main" {
  vpc_id = data.aws_vpc.existing_vpc.id

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "my_public_subnet1" {
  vpc_id                  = data.aws_vpc.existing_vpc.id
  cidr_block              = var.subnet1_cidr[0]
  availability_zone       = var.subnet_AZ[0]
  map_public_ip_on_launch = true

  tags = {
    Name                        = "my_public_subnet1"
    "kubernetes.io/cluster/my-drawing-app-cluster" = "shared"
    "kubernetes.io/role/elb"    = 1
  }
}

resource "aws_subnet" "my_private_subnet1" {
  vpc_id            = data.aws_vpc.existing_vpc.id
  cidr_block        = var.subnet1_cidr[1]
  availability_zone = var.subnet_AZ[0]


  tags = {
    Name                        = "my_private_subnet1"
    "kubernetes.io/cluster/my-drawing-app-cluster" = "shared"
  }
}

resource "aws_subnet" "my_public_subnet2" {
  vpc_id                  = data.aws_vpc.existing_vpc.id
  cidr_block              = var.subnet2_cidr[0]
  availability_zone       = var.subnet_AZ[1]
  map_public_ip_on_launch = true

  tags = {
    Name                        = "my_public_subnet2"
    "kubernetes.io/cluster/my-drawing-app-cluster" = "shared"
    "kubernetes.io/role/elb"    = 1
  }

}

resource "aws_subnet" "my_private_subnet2" {
  vpc_id            = data.aws_vpc.existing_vpc.id
  cidr_block        = var.subnet2_cidr[1]
  availability_zone = var.subnet_AZ[1]

  tags = {
    Name                        = "my_private_subnet2"
    "kubernetes.io/cluster/my-drawing-app-cluster" = "shared"
  }
}

resource "aws_eip" "nat1" {
  depends_on = [aws_internet_gateway.main]
}

resource "aws_eip" "nat2" {
  depends_on = [aws_internet_gateway.main]
}

resource "aws_nat_gateway" "gw1" {
  allocation_id = aws_eip.nat1.id
  subnet_id     = aws_subnet.my_public_subnet1.id

  tags = {
    Name = "NAT 1"
  }
}

resource "aws_nat_gateway" "gw2" {
  allocation_id = aws_eip.nat2.id
  subnet_id     = aws_subnet.my_public_subnet2.id

  tags = {
    Name = "NAT 2"
  }
}

resource "aws_route_table" "public" {
  vpc_id = data.aws_vpc.existing_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public"
  }
}

resource "aws_route_table" "private1" {
  vpc_id = data.aws_vpc.existing_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw1.id
  }

  tags = {
    Name = " private1"
  }
}

resource "aws_route_table" "private2" {
  vpc_id = data.aws_vpc.existing_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gw2.id
  }

  tags = {
    Name = " private2"
  }
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.my_public_subnet1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.my_private_subnet1.id
  route_table_id = aws_route_table.private1.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.my_public_subnet2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.my_private_subnet2.id
  route_table_id = aws_route_table.private2.id
}

resource "aws_security_group" "eks_sg" {
  name        = "eks_security_group"
  description = "Security group for EKS cluster"
  vpc_id      = data.aws_vpc.existing_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_iam_role" "eks_cluster_role" {
  name = "eks_cluster_role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "eks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_eks_cluster" "my_cluster" {
  name     = "my-drawing-app-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    endpoint_public_access = true

    subnet_ids = [
      aws_subnet.my_public_subnet1.id,
      aws_subnet.my_private_subnet1.id,
      aws_subnet.my_public_subnet2.id,
      aws_subnet.my_private_subnet2.id
    ]
    security_group_ids = [aws_security_group.eks_sg.id]
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy_attachment]
}

resource "aws_iam_role" "eks_worker_node" {
  name = "eks_worker_role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy_attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_worker_node.name
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy_attach" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_worker_node.name
}

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_regigtry_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_worker_node.name
}

resource "aws_iam_instance_profile" "eks_worker_instance_profile" {
  name = "eks_worker_instance_profile"
  role = aws_iam_role.eks_worker_node.name
}

resource "aws_eks_node_group" "my_node_group" {
  cluster_name    = aws_eks_cluster.my_cluster.name
  node_group_name = "my-node-group"
  node_role_arn   = aws_iam_role.eks_worker_node.arn
  subnet_ids      = [aws_subnet.my_private_subnet1.id, aws_subnet.my_private_subnet2.id]

  instance_types = [var.instance_types]

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  depends_on = [
    aws_iam_role_policy_attachment.amazon_ec2_container_regigtry_read_only,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy_attach,
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy_attach
  ]

}
