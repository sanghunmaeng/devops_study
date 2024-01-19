// Default SG
resource "aws_default_security_group" "test-vpc_sg_default"{

  vpc_id = aws_vpc.test-vpc.id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

########### Bastion (EC2 Instance) Security Group ###########

resource "aws_security_group" "test-sg-bastion" {

  name   = "test-sg-bastion"
  vpc_id = aws_vpc.test-vpc.id

  ingress {
    description = "ingress security_group_rule for bastion"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "egress security_group_rule for bastion"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "test-sg-bastion"
  }
}

############ EKS Security Group ###########
#// EKS Control Plane SG
#// - 컨트롤 플레인과 워커 노드 그룹 간의 통신
#resource "aws_security_group" "test-eks_sg_controlplane" {
#
#    vpc_id = aws_vpc.test-vpc.id
#    name = "Test-EKS-SG-ControlPlane"
#    description = "Communication between the control plane and worker nodegroups"
#
#    tags = {
#      "Name" = "Test-EKS-ControlPlane-SG"
#    }
#}
#
#// - 노드가 클러스터 API 서버와 통신하도록 허용
#resource "aws_security_group_rule" "test-eks_sg_cluster_inbound" {
#
#    security_group_id = aws_security_group.test-eks_sg_controlplane.id
#    source_security_group_id = aws_security_group.test-eks_sg_nodes.id
#
#    type = "ingress"
#    from_port = 443
#    to_port = 443
#    protocol = "tcp"
#    description = "Allow nodes to communicate with the cluster API Server"
#}
#
#// - 클러스터 API 서버가 워커 노드와 통신하도록 허용
#resource "aws_security_group_rule" "test-eks_sg_cluster_outbound" {
#
#    security_group_id = aws_security_group.test-eks_sg_controlplane.id
#    source_security_group_id = aws_security_group.test-eks_sg_nodes.id
#
#    type = "egress"
#    from_port = 1025
#    to_port = 65535
#    protocol = "tcp"
#    description = "Allow Cluster API Server to communicate with the worker nodes"
#}
#
#// EKS Worker Node SG
#// - 클러스터의 워커 노드에 대한 보안 그룹
#resource "aws_security_group" "test-eks_sg_nodes" {
#
#    vpc_id = aws_vpc.test-vpc.id
#    name = "Test-EKS-SG-NodeGroup"
#    description = "Security group for worker nodes in Cluster"
#
#    egress {
#      from_port   = 0
#      to_port     = 0
#      protocol    = "-1"
#      cidr_blocks = ["0.0.0.0/0"]
#    }
#
#    tags = {
#      "Name" = "Test-EKS-NodeGroup-SG"
#    }
#}
#
#// - 노드가 서로 통신하도록 허용
#resource "aws_security_group_rule" "test-eks_sg_nodes_internal" {
#
#    security_group_id = aws_security_group.test-eks_sg_nodes.id
#    source_security_group_id = aws_security_group.test-eks_sg_nodes.id
#
#    type = "ingress"
#    from_port = 0
#    to_port = 65535
#    protocol = "-1"
#    description = "Allow nodes to communicate with each other"
#}
#
#// - 워커 노드 Kubelet 및 Pod가 클러스터 컨트롤 플레인으로부터 통신을 수신하도록 허용
#resource "aws_security_group_rule" "test-eks_sg_nodes_inbound" {
#
#    security_group_id = aws_security_group.test-eks_sg_nodes.id
#    source_security_group_id = aws_security_group.test-eks_sg_controlplane.id
#
#    type = "ingress"
#    from_port = 1025
#    to_port = 65535
#    protocol = "tcp"
#    description = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
#}
#
#// - SSH 워커노드 Kubelet 및 Pod가 클러스터 컨트롤 플레인으로부터 통신을 수신하도록 허용
#resource "aws_security_group_rule" "test-eks_sg_nodes_ssh_inbound" {
#
#    security_group_id = aws_security_group.test-eks_sg_nodes.id
#    source_security_group_id = aws_security_group.test-eks_sg_controlplane.id
#
#    type = "ingress"
#    from_port = 443
#    to_port = 443
#    protocol = "tcp"
#    description = "Allow ssh worker Kubelets and pods to receive communication from the cluster control plane"
#}
