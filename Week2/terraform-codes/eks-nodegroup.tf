resource "aws_eks_node_group" "test-eks-nodegroup" {

  // 프로비저닝 전 IAM Role 생성 필요
  depends_on = [
    aws_iam_role_policy_attachment.test-eks_iam_cluster_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.test-eks_iam_cluster_AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.test-eks_iam_cluster_AmazonEKS_CNI_Policy
  ]

  // 클러스터 이름
  cluster_name = aws_eks_cluster.test-eks-cluster.name

  // 이름
  node_group_name = "test-eks-nodegroup"

  // 노드 IAM 역할
  node_role_arn = aws_iam_role.test-eks_iam_nodes.arn

  // AMI 유형
  ami_type = "AL2_x86_64"

  // 용량 유형
  capacity_type = "ON_DEMAND"

  // 인스턴스 유형
  instance_types = ["t3a.medium"]

  // 디스크 크기
  disk_size = 20

  // 노드 그룹 조정 구성
  scaling_config {

    // 원하는 크기
    desired_size = 4

    // 최소 크기
    min_size = 1

    // 최대 크기
    max_size = 4

  }

  // 서브넷
  subnet_ids = aws_subnet.test-public-subnet[*].id

  tags = {
    "Name" = "TEST-EKS-WORKER-NODES"
  }
}