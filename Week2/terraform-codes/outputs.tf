// 프로비저닝후 EKS 클러스터명 출력
output "cluster_name" {
  value = aws_eks_cluster.test-eks-cluster.name
}

// 프로비저닝후 EKS 엔드포인트 출력
output "cluster_endpoint" {
  value = aws_eks_cluster.test-eks-cluster.endpoint
}