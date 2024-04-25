output "alb_endpoint" {
  value = aws_lb.jenkins_script_alb.dns_name
}

# output "alb_sgs_id" {
#   value = aws_security_group.lb_sg.id
# }