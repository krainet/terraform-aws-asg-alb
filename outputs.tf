output "lb_internal" {
  value = var.create_internal_load_balancer ? aws_lb.internal[0] : null
}

output "lb_external" {
  value = var.create_external_load_balancer ? aws_lb.external[0] : null
}

output "lb_target_group_internal" {
  value = var.create_internal_load_balancer ? aws_lb_target_group.internal[0] : null
}

output "lb_target_group_external" {
  value = var.create_external_load_balancer ? aws_lb_target_group.external[0] : null
}

output "launch_template" {
  value = aws_launch_template.launch_template
}

output "autoscaling_group" {
  value = aws_autoscaling_group.autoscaling_group
}
