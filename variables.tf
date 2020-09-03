variable "name" {
  description = "Name"
  type        = string
}

variable "create_external_load_balancer" {
  description = "Create or not an external load balancer"
  type        = bool
  default     = false
}

variable "create_internal_load_balancer" {
  description = "Create or not an internal load balancer"
  type        = bool
  default     = false
}

variable "enable_sso_external_load_balancer" {
  description = "Enable SSO on external load balancer"
  type        = bool
  default     = false
}

variable "enable_sso_internal_load_balancer" {
  description = "Enable SSO on internal load balancer"
  type        = bool
  default     = false
}

variable "lb_subnet_ids" {
  description = "A list of subnet IDs to attach to the ALB"
  type        = list(string)
}

variable "lb_health_check_port" {
  description = "ALB health check port"
  type        = number
  default     = 80
}

variable "lb_health_check_port_internal" {
  description = "ALB health check port"
  type        = number
  default     = -1
}

variable "lb_health_check_protocol" {
  description = "ALB health check protocol"
  type        = string
  default     = "HTTP"
}

variable "lb_health_check_protocol_internal" {
  description = "ALB health check protocol"
  type        = string
  default     = ""
}

variable "lb_health_check_path" {
  description = "The URL the ALB should use for health checks. e.g. /health"
  type        = string
  default     = "/"
}

variable "lb_health_check_path_internal" {
  description = "The URL the ALB should use for health checks. e.g. /health"
  type        = string
  default     = ""
}

variable "lb_health_check_matcher" {
  description = "The status code for health check"
  type        = string
  default     = "200-299"
}

variable "lb_health_check_matcher_internal" {
  description = "The status code for healck check"
  type        = string
  default     = "200-299"
}


variable "lb_health_check_interval" {
  description = "The interval between checks"
  type        = number
  default     = 10
}

variable "lb_health_check_interval_internal" {
  description = "The interval between checks"
  type        = number
  default     = -1
}

variable "lb_stickiness_type_internal" {
  description = "ALB stickiness type"
  type        = string
  default     = "lb_cookie"
}

variable "lb_stickiness_cookie_duration_internal" {
  description = "ALB cookie duration type"
  type        = number
  default     = 600
}

variable "lb_stickiness_enabled_internal" {
  description = "ALB enable stickiness"
  type        = bool
  default     = false
}

variable "lb_stickiness_type_external" {
  description = "ALB stickiness type"
  type        = string
  default     = "lb_cookie"
}

variable "lb_stickiness_cookie_duration_external" {
  description = "ALB cookie duration type"
  type        = number
  default     = 600
}

variable "lb_stickiness_enabled_external" {
  description = "ALB enable stickiness"
  type        = bool
  default     = false
}

variable "lb_ssl_policy" {
  description = "The name of the SSL Policy for the listener. Required if protocol is HTTPS."
  type        = string
  default     = ""
}

variable "lb_external_certificate_arn" {
  description = "The ARN of the SSL server certificate. Exactly one certificate is required if the protocol is HTTPS."
  type        = string
  default     = ""
}

variable "lb_internal_certificate_arn" {
  description = "The ARN of the SSL server certificate. Exactly one certificate is required if the protocol is HTTPS."
  type        = string
  default     = ""
}

variable "lb_external_security_group_ids" {
  description = "List of security groups to attach to the external LB"
  type        = list(string)
  default     = []
}

variable "lb_internal_security_group_ids" {
  description = "List of security groups to attach to the internal LB"
  type        = list(string)
  default     = []
}

variable "lb_target_group_port" {
  description = "ALB target group port"
  type        = number
  default     = 80
}

variable "lb_target_group_port_internal" {
  description = "ALB target group port"
  type        = number
  default     = -1
}

variable "lb_target_group_protocol" {
  description = "ALB target group protocol"
  type        = string
  default     = "HTTP"
}

variable "lb_target_group_protocol_internal" {
  description = "ALB target group protocol"
  type        = string
  default     = ""
}

variable "lb_target_group_deregistration_delay" {
  description = "The amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused."
  type        = number
  default     = 10
}

variable "lb_target_group_deregistration_delay_internal" {
  description = "The amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused."
  type        = number
  default     = -1
}

variable "lb_listener_port_internal" {
  description = "ALB internal listener port"
  type        = number
  default     = 443
}

variable "lb_listener_protocol_internal" {
  description = "ALB internal listener protocol"
  type        = string
  default     = "HTTPS"
}

variable "lb_listener_port_external" {
  description = "ALB internal listener port"
  type        = number
  default     = 443
}

variable "lb_listener_protocol_external" {
  description = "ALB external listener protocol"
  type        = string
  default     = "HTTPS"
}

variable "launch_template_image_id" {
  description = "The EC2 image ID to launch"
  type        = string
}

variable "launch_template_instance_type" {
  description = "The size of instance to launch"
  type        = string
  default     = "t3.micro"
}

variable "launch_template_key_name" {
  description = "The key name that should be used for the instance"
  type        = string
}

variable "launch_template_user_data" {
  description = "User data for Launch Template"
  type        = string
}

variable "launch_template_associate_public_ip_address" {
  description = "Associate a public ip address with an instance in a VPC"
  type        = bool
  default     = false
}

variable "launch_template_enable_monitoring" {
  description = "Enables/disables detailed monitoring"
  type        = bool
  default     = false
}

variable "launch_template_root_block_device_name" {
  description = "The name of the root block device."
  type        = string
  default     = "/dev/xvda"
}

variable "launch_template_root_block_device_volume_type" {
  description = "The type of volume. Can be 'standard', 'gp2', or 'io1'"
  type        = string
  default     = "gp2"
}

variable "launch_template_root_block_device_volume_size" {
  description = "The size of the volume in gigabytes"
  type        = number
  default     = 8
}

variable "launch_template_security_groups" {
  description = "A list of associated security group IDS to be appended to the ones created by this module (only 2 SG allowed)"
  type        = list(string)
  default     = []
}

variable "launch_template_ebs_optimized" {
  description = "Enables/disables ebs optimized"
  type        = bool
  default     = true
}

variable "launch_template_disable_api_termination" {
  description = "If true, enables EC2 Instance Termination Protection"
  type        = bool
  default     = false
}

variable "launch_template_instance_profile" {
  type = string
}

variable "asg_min_size" {
  description = "The minimum size of the auto scale group"
  type        = number
  default     = 0
}

variable "asg_max_size" {
  description = "The maximum size of the auto scale group"
  type        = number
  default     = 0
}

variable "asg_desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group"
  type        = number
  default     = 0
}

variable "asg_subnet_ids" {
  description = "A list of subnet IDs to launch resources in"
  type        = list(string)
}

variable "asg_termination_policies" {
  description = "A list of policies to decide how the instances in the auto scale group should be terminated"
  type        = list(string)
  default     = []
}

variable "asg_suspended_processes" {
  description = "A list of processes to suspend for the AutoScaling Group"
  type        = list(string)
  default     = []
}

variable "asg_health_check_grace_period" {
  description = "Time (in seconds) after instance comes into service before checking health"
  type        = number
  default     = 300
}

variable "asg_health_check_type" {
  description = "Controls how health checking is done. Can be 'ELB' or 'EC2'"
  type        = string
  default     = "ELB"
}

variable "asg_enabled_metrics" {
  description = "A list of metrics to collect"
  type        = list(string)
  default     = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
}

variable "asg_protect_from_scale_in" {
  description = "Allows setting instance protection. The autoscaling group will not select instances with this setting for terminination during scale in events."
  type        = bool
  default     = false
}

variable "asg_metrics_granularity" {
  description = "The granularity to associate with the metrics to collect. The only valid value is 1Minute"
  type        = string
  default     = "1Minute"
}

variable "asg_on_demand_base_capacity" {
  description = "Absolute minimum amount of desired capacity that must be fulfilled by on-demand instances"
  type        = number
  default     = 0
}

variable "asg_on_demand_percentage_above_base_capacity" {
  description = "Percentage split between on-demand and Spot instances above the base on-demand capacity"
  type        = number
  default     = 100
}

variable "asg_spot_allocation_strategy" {
  description = "How to allocate capacity across the Spot pools"
  type        = string
  default     = "lowest-price"
}

variable "asg_spot_instance_pools" {
  description = "Number of Spot pools per availability zone to allocate capacity"
  type        = number
  default     = 2
}

variable "asg_launch_template_overrides" {
  description = "List that provides the ability to specify multiple instance types"
  type        = list(object({ instance_type = string, weighted_capacity = number }))
  default     = []
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

# SSO params for Okta OIDC authentication
###########################################

variable "lb_action_type" {
  description = "ALB action type"
  type        = string
  default     = "authenticate-oidc"
}

variable "lb_authorization_endpoint" {
  description = "ALB auth endpoint"
  type        = string
  default     = ""
}

variable "lb_auth_client_id" {
  description = "ALB auth client ID"
  type        = string
  default     = ""
}

variable "lb_auth_client_secret" {
  description = "ALB auth client secret"
  type        = string
  default     = ""
}

variable "lb_auth_issuer" {
  description = "ALB auth issuer"
  type        = string
  default     = ""
}

variable "lb_auth_token_endpoint" {
  description = "ALB token endpoint"
  type        = string
  default     = ""
}

variable "lb_auth_userinfo_endpoint" {
  description = "ALB auth userinfo endpoint"
  type        = string
  default     = ""
}

variable "lb_listener_rule_priority" {
  description = "ALB listener rule priority"
  type        = number
  default     = 100
}

variable "lb_listener_rule_action_type" {
  description = "ALB listener rule action type"
  type        = string
  default     = "forward"
}

variable "lb_listener_rule_condition_field" {
  description = "ALB listener rule condition field"
  type        = string
  default     = "path-pattern"
}

variable "lb_listener_rule_condition_value" {
  description = "ALB listener rule condition value"
  type        = string
  default     = "/*"
}

variable "lb_external_count_sso" {
  description = "number of external authenticated ALBs"
  type        = number
  default     = 0
}

variable "lb_internal_count_sso" {
  description = "number of internal authenticated ALBs "
  type        = number
  default     = 0
}