resource "aws_launch_template" "this" {

  count         = length(var.zones)
  key_name      = var.ssh_key_name
  name          = "${var.name}-instance-${var.zones[count.index]}"
  image_id      = data.aws_ami.this.image_id
  instance_type = var.instance_type
  iam_instance_profile {
    arn = aws_iam_instance_profile.this.arn
  }
  ebs_optimized = true
  maintenance_options {
    auto_recovery = "default"
  }
  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    security_groups             = [aws_security_group.this.id]
  }
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 8
      volume_type           = "gp3"
      encrypted             = true
      delete_on_termination = true
    }
  }
  update_default_version = true
  user_data              = data.cloudinit_config.this[count.index].rendered
}

resource "aws_autoscaling_group" "this" {
  count                     = length(var.zones)
  name                      = "${var.name}-${var.zones[count.index]}-asg"
  max_size                  = 1
  min_size                  = 1
  capacity_rebalance        = true
  desired_capacity          = 1
  health_check_type         = "EC2"
  health_check_grace_period = 60
  launch_template {
    id      = aws_launch_template.this[count.index].id
    version = "$Latest"
  }
  termination_policies = ["OldestLaunchTemplate"]
  vpc_zone_identifier  = [var.public_subnet_ids[count.index]]
  tag {
    key                 = "Name"
    value               = "${var.name}-${var.zones[count.index]}-instance"
    propagate_at_launch = true
  }
  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity]
  }
}