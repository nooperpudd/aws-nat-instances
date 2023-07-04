data "aws_availability_zone" "current" {
  state = "available"
}

data "aws_ami" "this" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-6.1-*"]
  }
  filter {
    name   = "architecture"
    values = [var.architecture]
  }
}

data "cloudinit_config" "this" {
  count         = length(var.zones)
  gzip          = false
  base64_encode = true
  part {
    filename     = "init.yaml"
    content_type = "text/cloud-config"
    content = templatefile("config/init.yaml", {
      vpc_cidr          = var.vpc_cidr
      route_table_id    = var.private_route_table_ids[count.index]
      eip_allocation_id = aws_eip.this[count.index].allocation_id
    })
  }
}