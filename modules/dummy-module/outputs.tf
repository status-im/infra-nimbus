output "public_ips" {
  value = var.ips
}

output "hostnames" {
  value = values(local.hostnames)
}

output "hosts" {
  value = zipmap(values(local.hostnames), var.ips)
}
