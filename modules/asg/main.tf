resource "aws_launch_template" "this" {
  name          = "${var.PROJECT_NAME}-tpl"
  image_id      = var.AMI
  instance_type = var.CPU
  key_name      = var.KEY_NAME
  user_data     = filebase64("../modules/asg/config.sh")


  # network_interfaces {
  #   associate_public_ip_address = false
  # }
  vpc_security_group_ids = [var.CLIENT_SG_ID]
  tags = {
    Name = "${var.PROJECT_NAME}-tpl"
  }
}

resource "aws_autoscaling_group" "this" {

  name                      = "${var.PROJECT_NAME}-asg"
  max_size                  = var.MAX_SIZE
  min_size                  = var.MIN_SIZE
  desired_capacity          = var.DESIRED_CAP
  health_check_grace_period = 300
  health_check_type         = var.asg_health_check_type #"ELB" or default EC2
  #availability_zones = var.availability_zones #["us-east-1a"]
  vpc_zone_identifier = [var.PRI_SUB_3_A_ID,var.PRI_SUB_4_B_ID]
  target_group_arns   = [var.TG_ARN] #var.target_group_arns

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"

  launch_template {
    id      = aws_launch_template.this.id
    version = aws_launch_template.this.latest_version #"$Latest"
  }
#   depends_on = [module.aws_lb]
}

# scale up policy
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${var.PROJECT_NAME}-asg-scale-up"
  autoscaling_group_name = aws_autoscaling_group.this.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1" #increasing instance by 1 
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

# scale up alarm
# alarm will trigger the ASG policy (scale/down) based on the metric (CPUUtilization), comparison_operator, threshold
resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name          = "${var.PROJECT_NAME}-asg-scale-up-alarm"
  alarm_description   = "asg-scale-up-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30" # New instance will be created once CPU utilization is higher than 30 %
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.this.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale_up.arn]
}

# scale down policy
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "${var.PROJECT_NAME}-asg-scale-down"
  autoscaling_group_name = aws_autoscaling_group.this.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1" # decreasing instance by 1 
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

# scale down alarm
resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name          = "${var.PROJECT_NAME}-asg-scale-down-alarm"
  alarm_description   = "asg-scale-down-cpu-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "5" # Instance will scale down when CPU utilization is lower than 5 %
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.this.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale_down.arn]
}
