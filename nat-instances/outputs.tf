output "eip_address_list" {
  value = aws_eip.this.*.address
}
