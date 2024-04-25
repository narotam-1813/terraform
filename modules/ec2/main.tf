resource "aws_security_group" "instance_sg" {
  name = var.instance_sg_name
  vpc_id = var.sg_vpc_id
  # ingress {        ## Uncomment it when you want to access ec2 using ssh
  #   from_port = 22
  #   to_port = 22
  #   protocol = "tcp"
  #   cidr_blocks = [ "0.0.0.0/0" ]
  # }
  # ingress{
  #   from_port = 80
  #   to_port = 80
  #   protocol = "tcp"
  #   cidr_blocks = [ "0.0.0.0/0" ]
  # }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "TCP"
    security_groups = [ var.lb_sg_id ]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol   = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

data "template_file" "jenkins_script" {
 template = file("/home/narotam/practice/netflix_project/terraform/modules/scripts/Jenkins.sh")
}

resource "aws_instance" "ec2" {
    count = var.number_of_instances
    ami = var.instance_ami
    instance_type = var.instance_type
    subnet_id = var.subnet_id[0]
    key_name = data.aws_key_pair.instance_key.key_name
    # associate_public_ip_address = true
    vpc_security_group_ids = [ aws_security_group.instance_sg.id ]
    user_data = data.template_file.jenkins_script.rendered
    iam_instance_profile = aws_iam_instance_profile.jenkins-resources-iam-profile.name
    # provisioner "file" {                                        >>## Uncomment it when you want to run jenkins script using ssh access
    #   source = "/home/narotam/practice/netflix_project/terraform/modules/scripts/Jenkins.sh"
    #   destination = "/tmp/Jenkins.sh"
    # }
    # provisioner "remote-exec" {
    #   inline = [ 
    #     "chmod +x /tmp/Jenkins.sh",
    #     "bash /tmp/Jenkins.sh"
    #    ]
    # }
    # connection {
    #   type = "ssh"
    #   user = "ec2-user"
    #   private_key = file("~/Downloads/narotam_test.pem")
    #   host = self.public_ip
    # }                                                       ##<<
    tags = {
        "Name" = var.instance_name
    }
}