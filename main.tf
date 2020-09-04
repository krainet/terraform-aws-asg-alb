locals {
  lb_health_check_port_internal                 = var.lb_health_check_port_internal != -1 ? var.lb_health_check_port_internal : var.lb_health_check_port
  lb_health_check_protocol_internal             = var.lb_health_check_protocol_internal != "" ? var.lb_health_check_protocol_internal : var.lb_health_check_protocol
  lb_health_check_path_internal                 = var.lb_health_check_path_internal != "" ? var.lb_health_check_path_internal : var.lb_health_check_path
  lb_health_check_interval_internal             = var.lb_health_check_interval_internal != -1 ? var.lb_health_check_interval_internal : var.lb_health_check_interval
  lb_health_check_matcher_internal              = var.lb_health_check_matcher_internal != "" ? var.lb_health_check_matcher_internal : var.lb_health_check_matcher

  lb_target_group_deregistration_delay_internal = var.lb_target_group_deregistration_delay_internal != -1 ? var.lb_target_group_deregistration_delay_internal : var.lb_target_group_deregistration_delay

  lb_target_group_port_internal     = var.lb_target_group_port_internal != -1 ? var.lb_target_group_port_internal : var.lb_target_group_port
  lb_target_group_protocol_internal = var.lb_target_group_protocol_internal != "" ? var.lb_target_group_protocol_internal : var.lb_target_group_protocol

  create_lb_internal = var.create_internal_load_balancer ? 1 : 0
  create_lb_external = var.create_external_load_balancer ? 1 : 0
}

resource "aws_lb" "internal" {
  count           = local.create_lb_internal
  name            = "${var.name}-int"
  subnets         = var.lb_subnet_ids
  security_groups = var.lb_internal_security_group_ids
  internal        = "true"

  tags = merge(
    {
      Name        = var.name
      provisioned = "terraform"
    },
    var.tags
  )
}

resource "aws_lb" "external" {
  count           = local.create_lb_external
  name            = "${var.name}-ext"
  subnets         = var.lb_subnet_ids
  security_groups = var.lb_external_security_group_ids
  internal        = "false"

  tags = merge(
    {
      Name        = var.name
      provisioned = "terraform"
    },
    var.tags,
  )
}

resource "aws_lb_target_group" "internal" {
  count                = local.create_lb_internal
  name                 = "${var.name}-int"
  port                 = local.lb_target_group_port_internal
  protocol             = local.lb_target_group_protocol_internal
  vpc_id               = var.vpc_id
  deregistration_delay = local.lb_target_group_deregistration_delay_internal

  health_check {
    interval = local.lb_health_check_interval_internal
    path     = local.lb_health_check_path_internal
    protocol = local.lb_health_check_protocol_internal
    port     = local.lb_health_check_port_internal
    matcher  = local.lb_health_check_matcher_internal
  }

  stickiness {
    type              = var.lb_stickiness_type_internal
    cookie_duration   = var.lb_stickiness_cookie_duration_internal
    enabled           = var.lb_stickiness_enabled_internal
  }

  tags = merge(
    {
      Name        = var.name
      provisioned = "terraform"
    },
    var.tags,
  )
}

resource "aws_lb_target_group" "external" {
  count                = local.create_lb_external
  name                 = "${var.name}-ext"
  port                 = var.lb_target_group_port
  protocol             = var.lb_target_group_protocol
  vpc_id               = var.vpc_id
  deregistration_delay = var.lb_target_group_deregistration_delay

  health_check {
    interval = var.lb_health_check_interval
    path     = var.lb_health_check_path
    protocol = var.lb_health_check_protocol
    port     = var.lb_health_check_port
    matcher  = var.lb_health_check_matcher
  }
  
  stickiness {
    type              = var.lb_stickiness_type_external
    cookie_duration   = var.lb_stickiness_cookie_duration_external
    enabled           = var.lb_stickiness_enabled_external
  }

  tags = merge(
    {
      Name        = var.name
      provisioned = "terraform"
    },
    var.tags,
  )
}

resource "aws_lb_listener" "internal" {
  count             = local.create_lb_internal
  load_balancer_arn = aws_lb.internal[0].arn
  port              = var.lb_listener_port_internal
  protocol          = var.lb_listener_protocol_internal
  certificate_arn   = var.lb_internal_certificate_arn
  ssl_policy        = var.lb_ssl_policy

  default_action {
    target_group_arn = aws_lb_target_group.internal[0].arn
    type             = "forward"
  }
}

resource "aws_lb_listener" "external" {
  count             = local.create_lb_external
  load_balancer_arn = aws_lb.external[0].arn
  port              = var.lb_listener_port_external
  protocol          = var.lb_listener_protocol_external
  certificate_arn   = var.lb_external_certificate_arn
  ssl_policy        = var.lb_ssl_policy

  default_action {
    target_group_arn = aws_lb_target_group.external[0].arn
    type             = "forward"
  }
}

resource "aws_lb_listener_rule" "internal" {
  count        = var.enable_sso_internal_load_balancer && local.create_lb_internal > 0 ? 1 : 0
  listener_arn = aws_lb_listener.internal[0].arn
  priority     = var.lb_listener_rule_priority

  action {
    type = var.lb_action_type

    authenticate_oidc {
      authorization_endpoint = var.lb_authorization_endpoint
      client_id              = var.lb_auth_client_id
      client_secret          = var.lb_auth_client_secret
      issuer                 = var.lb_auth_issuer
      token_endpoint         = var.lb_auth_token_endpoint
      user_info_endpoint     = var.lb_auth_userinfo_endpoint
    }
  }

  action {
    type             = var.lb_listener_rule_action_type
    target_group_arn = aws_lb_target_group.internal[0].arn
  }

  condition {
    path_pattern {
      values = [var.lb_listener_rule_condition_value]
    }
  }
}

resource "aws_lb_listener_rule" "external" {
  count        = var.enable_sso_external_load_balancer && local.create_lb_external > 0 ? 1 : 0
  listener_arn = aws_lb_listener.external[0].arn
  priority     = var.lb_listener_rule_priority

  action {
    type = var.lb_action_type

    authenticate_oidc {
      authorization_endpoint = var.lb_authorization_endpoint
      client_id              = var.lb_auth_client_id
      client_secret          = var.lb_auth_client_secret
      issuer                 = var.lb_auth_issuer
      token_endpoint         = var.lb_auth_token_endpoint
      user_info_endpoint     = var.lb_auth_userinfo_endpoint
    }
  }

  action {
    type             = var.lb_listener_rule_action_type
    target_group_arn = aws_lb_target_group.external[0].arn
  }

  condition {
    path_pattern {
      values = [var.lb_listener_rule_condition_value]
    }
  }
}

resource "aws_launch_template" "launch_template" {
  name_prefix                          = "${var.name}-"
  disable_api_termination              = var.launch_template_disable_api_termination
  ebs_optimized                        = var.launch_template_ebs_optimized
  image_id                             = var.launch_template_image_id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = var.launch_template_instance_type
  key_name                             = var.launch_template_key_name
  user_data                            = base64encode(var.launch_template_user_data)

  block_device_mappings {
    device_name = var.launch_template_root_block_device_name

    ebs {
      delete_on_termination = true
      volume_type           = var.launch_template_root_block_device_volume_type
      volume_size           = var.launch_template_root_block_device_volume_size
    }
  }

  iam_instance_profile {
    name = var.launch_template_instance_profile
  }

  monitoring {
    enabled = var.launch_template_enable_monitoring
  }

  network_interfaces {
    associate_public_ip_address = var.launch_template_associate_public_ip_address
    security_groups             = var.launch_template_security_groups
    delete_on_termination       = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = var.tags
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "autoscaling_group" {
  name                      = var.name
  min_size                  = var.asg_min_size
  max_size                  = var.asg_max_size
  desired_capacity          = var.asg_desired_capacity
  vpc_zone_identifier       = var.asg_subnet_ids
  termination_policies      = var.asg_termination_policies
  suspended_processes       = var.asg_suspended_processes
  health_check_grace_period = var.asg_health_check_grace_period
  health_check_type         = var.asg_health_check_type
  protect_from_scale_in     = var.asg_protect_from_scale_in
  target_group_arns         = concat(aws_lb_target_group.internal.*.arn, aws_lb_target_group.external.*.arn)
  enabled_metrics           = var.asg_enabled_metrics
  metrics_granularity       = var.asg_metrics_granularity

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = var.asg_on_demand_base_capacity
      on_demand_percentage_above_base_capacity = var.asg_on_demand_percentage_above_base_capacity
      spot_allocation_strategy                 = var.asg_spot_allocation_strategy
      spot_instance_pools                      = var.asg_spot_instance_pools
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.launch_template.id
        version            = "$Latest"
      }

      dynamic "override" {
        for_each = var.asg_launch_template_overrides
        content {
          instance_type     = override.value.instance_type
          weighted_capacity = override.value.weighted_capacity
        }
      }
    }
  }

  tag {
    key                 = "provisioned"
    value               = "terraform"
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = var.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}