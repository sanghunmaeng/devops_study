// 리전 변수 - 서울 리전
variable "aws_region" {
  default = "ap-northeast-2"
  type = string 
}

// VPC CIDR - IP 대역, 최대 65,535개 IP 생성
variable "aws_vpc_cidr_block" {
    default = "172.31.0.0/16"
    type = string
}

// 서브넷 CIDR - IP 대역, 서브넷당 최대 4094개 IP 생성
variable "aws_vpc_public_subnets" {
    default = ["172.31.0.0/20", "172.31.16.0/20"]
    type = list(string)
}

// 가용 영역 - A존, C존
variable "aws_azs"  {
    default = ["ap-northeast-2a", "ap-northeast-2c"]
    type = list(string)
}

#// EKS 클러스터명
#variable "cluster-name" {
#  default = "test-eks-cluster"
#  type    = string
#}