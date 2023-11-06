output "cluster_endpoint" {
  value       = aws_eks_cluster.my_cluster.endpoint
  description = "The endpoint for your EKS Kubernetes API."
}

output "kubeconfig_certificate_authority_data" {
  value       = aws_eks_cluster.my_cluster.certificate_authority[0].data
  description = "The base64 encoded certificate data required to communicate with your cluster."
}

output "subnet_ids" {
  value       = [aws_subnet.my_public_subnet1.id, aws_subnet.my_public_subnet2.id]
  description = "The IDs of the subnets used by the EKS cluster"
}

output "security_group_id" {
  value       = aws_security_group.eks_sg.id
  description = "The ID of the security group used by the EKS cluster"
}

output "eks_worker_instance_profile_arn" {
  value       = aws_iam_instance_profile.eks_worker_instance_profile.arn
  description = "The ARN of the IAM instance profile used by the EKS worker nodes"
}

output "node_group_arn" {
  value       = aws_eks_node_group.my_node_group.arn
  description = "The ARN of the EKS node group"
}