resource "aws_eip" "this" {
  count  = length(var.zones)
  domain = "vpc"
  tags = {
    Name = "NAT-${var.zones[count.index]}"
  }
}

