resource "aws_instance" "test-ec2-bastion" {

  // 이름 및 태그
  tags = {
      Name = "test-ec2-bastion"
  }

  // Amazon Machine Image(AMI)
  ami = "ami-0bfd23bc25c60d5a1"

  // 인스턴스 유형
  instance_type = "t2.micro"

  // 키 페어(로그인)
  key_name = "test-ssh-key"

  //서브넷
  subnet_id = aws_subnet.test-public-subnet[1].id

  // 가용 영역
  availability_zone = "ap-northeast-2c"

  // 퍼블릭 IP 자동 할당
  associate_public_ip_address = "true"

  // 방화벽(보안 그룹)
  vpc_security_group_ids = [aws_security_group.test-sg-bastion.id]

  // 스토리지 구성
  root_block_device {

      // 볼륨 용량(GB)
      volume_size = "30"

      // 볼륨 타입
      volume_type = "gp3"
  }

  // IAM 인스턴스 프로필 할당
  iam_instance_profile = aws_iam_instance_profile.test-ec2-instance-profile.name

}