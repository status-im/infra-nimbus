output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_id" {
  value = aws_subnet.main.id
}

output "secgroup_id" {
  value = aws_security_group.main.id
}
