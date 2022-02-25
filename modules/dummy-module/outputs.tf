output "public_ips" {
  value = var.ips
}

output "hostnames" {
  value = keys(local.hostnames)
}

output "hosts" {
  value = local.hostnames
}
