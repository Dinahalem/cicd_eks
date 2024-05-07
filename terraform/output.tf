output "cluster1_id" {
  description = "EKS cluster ID for cluster 1."
  value       = module.eks_cluster1.cluster_id
}

output "cluster1_endpoint" {
  description = "Endpoint for EKS control plane for cluster 1."
  value       = module.eks_cluster1.cluster_endpoint
}

output "cluster1_security_group_id" {
  description = "Security group ids attached to the control plane for cluster 1."
  value       = module.eks_cluster1.cluster_security_group_id
}


output "region" {
  description = "AWS region"
  value       = var.aws_region
}

output "oidc_provider_arn" {
  value = module.eks_cluster1.oidc_provider_arn  
}
