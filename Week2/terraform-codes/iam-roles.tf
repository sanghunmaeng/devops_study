############ bastion ec2 instance iam role ############

// - EC2 인스턴스가 사용자를 대신하여 AWS 서비스를 호출하도록 허용
resource "aws_iam_role" "test-iam-role-ec2-instance-bastion" {

  // 신뢰할 수 있는 엔터티 - 지정된 조건에서 이 역할을 수임할 수 있는 엔터티
  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }
    }
  ],
  "Version": "2012-10-17"
}
POLICY
  name                 = "test-iam-role-ec2-instance-bastion"
  description          = "Iam role for bastion ec2 instance."
  max_session_duration = "3600"
  path                 = "/"

  tags = {
    Name        = "test-iam-role-ec2-instance-bastion"
  }

  tags_all = {
    Name        = "test-iam-role-ec2-instance-bastion"
  }
}

########### eks cluster and nodegroup iam role ############

// EKS Cluster IAM Role - EKS에서 관리하는 클러스터를 운영하는 데 필요한 다른 AWS 서비스 리소스에 대한 액세스를 허용
resource "aws_iam_role" "test-eks_iam_cluster" {
  name = "TEST-EKS-IAM-CLUSTER"

  // 신뢰할 수 있는 엔터티 - 지정된 조건에서 이 역할을 수임할 수 있는 엔터티
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

// EKS Cluster IAM Policy - Kubernetes가 사용자를 대신하여 인스턴스, 보안 그룹, 탄력적 네트워크 인터페이스등의 리소스를 관리하는 데 필요한 권한을 제공
resource "aws_iam_role_policy_attachment" "test-eks_iam_cluster_AmazonEKSClusterPolicy" {
  role = aws_iam_role.test-eks_iam_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

// EKS Worker Node IAM Role - EC2 인스턴스가 사용자를 대신하여 AWS 서비스를 호출하도록 허용
resource "aws_iam_role" "test-eks_iam_nodes" {
  name = "TEST-EKS-IAM-WORKERNODE"

  // 신뢰할 수 있는 엔터티 - 지정된 조건에서 이 역할을 수임할 수 있는 엔터티
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

// EKS Worker Node IAM Policy
// - 이 정책을 사용하면 Amazon EKS 작업자 노드가 Amazon EKS 클러스터에 연결할 수 있음
resource "aws_iam_role_policy_attachment" "test-eks_iam_cluster_AmazonEKSWorkerNodePolicy" {
  role = aws_iam_role.test-eks_iam_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

// - Amazon EC2 Container Registry 리포지토리에 대한 읽기 전용 액세스를 제공
resource "aws_iam_role_policy_attachment" "test-eks_iam_cluster_AmazonEC2ContainerRegistryReadOnly" {
  role = aws_iam_role.test-eks_iam_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

// - 이 정책은 EKS 작업자 노드에서 IP 주소 구성을 수정하는 데 필요한 권한을 Amazon VPC CNI 플러그인(amazon-vpc-cni-k8s)에 제공
// - 이 권한 집합을 사용하면 CNI가 사용자를 대신하여 탄력적 네트워크 인터페이스를 나열, 설명 및 수정할 수 있음
resource "aws_iam_role_policy_attachment" "test-eks_iam_cluster_AmazonEKS_CNI_Policy" {
  role = aws_iam_role.test-eks_iam_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}