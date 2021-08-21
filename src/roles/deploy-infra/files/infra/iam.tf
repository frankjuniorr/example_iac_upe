######################################################
# IAM Role
######################################################
resource "aws_iam_role" "upe_role" {
  name = var.upe_role_name

  assume_role_policy = <<EOF
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
EOF

  tags = {
    Provisioning = var.tag_provisioning
  }
}

######################################################
# Attach policies in the role
######################################################
resource "aws_iam_role_policy_attachment" "upe_role_attach_admin_access" {
  role       = aws_iam_role.upe_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

######################################################
# "Instace Profile", this is the resource that should be associated with EC2
######################################################
resource "aws_iam_instance_profile" "upe_instance_profile" {
  name = "upe_instance_profile"
  role = aws_iam_role.upe_role.name
}
