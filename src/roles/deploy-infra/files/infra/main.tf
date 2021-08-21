provider "aws" {
  region = var.region_id
}

######################################################
# SSH Key Pairs
######################################################
resource "aws_key_pair" "upe_ec2_key_pair" {
  key_name   = var.aws_key_pair
  public_key = var.ssh_public_key
}

######################################################
# Security Group
######################################################
resource "aws_security_group" "upe_sg" {
  name        = var.upe_security_group
  description = "EC2 Security Group to UPE Example IaC code"

  tags = {
    Provisioning = var.tag_provisioning
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
}


######################################################
# EC2
######################################################
data "aws_ami" "ubuntu_18_04" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "ec2_upe_example" {
  key_name                    = var.aws_key_pair
  instance_type               = "t2.micro"
  ami                         = data.aws_ami.ubuntu_18_04.id
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.upe_instance_profile.name
  tags = {
    Name = var.tag_ec2_name
    Provisioning = var.tag_provisioning
  }
  vpc_security_group_ids      = [aws_security_group.upe_sg.id]
}

data "aws_instance" "ec2_data" {
  instance_id = aws_instance.ec2_upe_example.id

  depends_on = [
    aws_instance.ec2_upe_example,
  ]
}