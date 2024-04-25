# resource "aws_security_group" "lb_sg" {
#   name = var.lb_sg_name
#   vpc_id = var.sg_vpc_id
#   ingress {
#     from_port = 80
#     to_port = 80
#     protocol = "tcp"
#     cidr_blocks = [ "0.0.0.0/0" ]
#   }
#   egress {
#     from_port = 0
#     to_port = 0
#     protocol   = "-1"
#     cidr_blocks = [ "0.0.0.0/0" ]
#   }
# }

resource "aws_lb" "jenkins_script_alb" {
    name = "jenkins-alb"
    internal = false
    load_balancer_type = "application"
    security_groups = [ var.lb_sg_id ]
    # subnet_mapping {
    #   subnet_id = var.lb_subnet_id
    #   allocation_id = var.eip_id
    # }
    subnets = var.lb_subnet_id[0]
    tags = {
      "Name" = "jenkins-alb"
    }
}

resource "aws_lb_target_group" "alb_tg" {
    name = "jenkins-lb-target-group"
    port = 8080
    protocol = "HTTP"
    vpc_id = var.sg_vpc_id
}

resource "aws_lb_listener" "jenkins_listener" {
  load_balancer_arn = aws_lb.jenkins_script_alb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "jenkin_alb_tg_attachment" {
  count = var.number_of_target_instances
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id = var.instance_id[count.index]
  port = 8080
}