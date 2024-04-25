resource "aws_iam_instance_profile" "jenkins-resources-iam-profile" {
name = "ec2_profile"
role = aws_iam_role.jenkins-ssm-resources-iam-role.name
}
resource "aws_iam_role" "jenkins-ssm-resources-iam-role" {
name        = "jenkins-ssm-role"
description = "The role for the jenkins ssm resources EC2"
assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": {
"Effect": "Allow",
"Principal": {"Service": "ec2.amazonaws.com"},
"Action": "sts:AssumeRole"
}
}
EOF
tags = {
stack = "jenkins-ssm"
}
}
resource "aws_iam_role_policy_attachment" "jenkins-resources-ssm-policy" {
role       = aws_iam_role.jenkins-ssm-resources-iam-role.name
policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}