
output "cluster_endpoint" {
  value       = module.eks_cluster.cluster_endpoint
  description = "The endpoint for your EKS Kubernetes API."
}

output "kubeconfig_certificate_authority_data" {
  value       = module.eks_cluster.kubeconfig_certificate_authority_data
  description = "The base64 encoded certificate data required to communicate with your cluster."
}

output "subnet_ids" {
  value       = module.eks_cluster.subnet_ids
  description = "The IDs of the subnets used by the EKS cluster"
}

output "security_group_id" {
  value       = module.eks_cluster.security_group_id
  description = "The ID of the security group used by the EKS cluster"
}

output "eks_worker_instance_profile_arn" {
  value       = module.eks_cluster.eks_worker_instance_profile_arn
  description = "The ARN of the IAM instance profile used by the EKS worker nodes"
}

output "node_group_arn" {
  value       = module.eks_cluster.node_group_arn
  description = "The ARN of the EKS node group"
}
