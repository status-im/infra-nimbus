/* DATA -----------------------------------------*/

terraform {
  backend "consul" {
    address = "https://consul.statusim.net:8400"
    /* Lock to avoid syncing issues */
    lock = true
    /* KV store has a limit of 512KB */
    gzip = true
    /* WARNING This needs to be changed for every repo. */
    path      = "terraform/nimbus/"
    ca_file   = "ansible/files/consul-ca.crt"
    cert_file = "ansible/files/consul-client.crt"
    key_file  = "ansible/files/consul-client.key"
  }
}

/* CF Zones ------------------------------------*/

/* CloudFlare Zone IDs required for records */
data "cloudflare_zones" "active" {
  filter { status = "active" }
}

/* For easier access to zone ID by domain name */
locals {
  zones = {
    for zone in data.cloudflare_zones.active.zones :
    zone.name => zone.id
  }
}

/* ACCESS KEY ------------------------------------------------------*/

resource "aws_key_pair" "jakubgs" {
  key_name   = "jakubgs"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5NIT2SVFFjV+ZraPBES45z8wkJf769P7AXdZ4FiJw+DcXKawNJCUefeBQY5GVofVOzOHUrkYLqzxVJihIZJaDgeyME/4pLXYztkk9EOWdQSadxLJjWItMJULJrh5nnXzKxv5yy1SGJCTcMSXrvR6JRduu+KTHGncXJ2Ze6Bdgm63sOdfyPCITSC+nc4GexYLAQmBxXCwtKieqfWVmKpazlVDxAg3Q1h2UXOuLTjkWomvzVCggwhzHtN/STQMCH49PlW/VoIBlrpYqlmRGObsdBae4Bk/D5ZpisJi6w573RcF9q3VrqJTHLiSpntfVJEtsbmyiNNckIujQfRk2KYvSCK2iGP17hfCE9HmEfSZNWrKrMqKJ7gHOhXHJrszh6TtN9zmgomPvYolJBLz/2/JC8swfixHPMzxQa+P2NyqC0yWg8Xqd1JLWKLHsLwpEYvmOfyYIY8zOfk7y3OJX8h7D/fgbnG/V75EVuZDc8sqXTJpj3esoEsz8XVu9cVraAOodG4zYKFnoTomAzBJtImh6ghSEDGT5BAvDyFySyJGMibCsG5DwaLvZUcijEkKke7Z7OoJR4qp0JABhbFn0efd/XGo2ZyGtJsibSW7ugayibEK7bDaYAW3lNXgpcDqpBiDcJVQG/UhhCSSrTsG0IUSbvSsrDuF6gCJWVKt4+klvLw== jakub@status.im"
}

resource "aws_key_pair" "artur" {
  key_name   = "artur"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDIzZmkPKG7C4LXmElt6vFQ2D7QD2cwt1/HWYBxak5YujTDHZEoRtf/LIpGOTctCWTkjvcN89M8Bz1m3InD9C6qn4MMMrpnw3OuBmHSef8tQr9CUf18xLHV8eshMnpQA9ixSOEBuNdlYTuhdC5wVBxSlkoArs86JGKFEqJXPs0FPP3Qz1+Mt6ZY+mMLr4MF4rqIaq+x/LVqAIEjEWVvw/YxbAPImV1wInQolFABY8nQIjycAkr9Gedwe0eJqMZAYR4O1ka70y2DDKfs1HhFd1RTDQdiRcuJtwVIZmqilW5xpL4pvh9WZ+0ERql+M2gsVuOo5A9o3V4l5DKV422myhC3I2JCiqr70/04PMQvztqVBIRk+q2Usuo5pPxqJWVWsBzaO0WO30YQjD+hSjm+XQaG1fgIYfIR1vFe6gWKfE5IxKE9i/EDkBSnIyWYIDiKLWhJxE9Js6bobDs5lHa0PDE+Pin9vpzliKtD1A8dI9jBcwA6hE+DIU1tCqUaOHDjb9b+CHJbziBEWSi001xnHYT8ltuND/zAFfl2+OTCfMBXErp96aFcpHpY9JQKwxgVp7jcNCa182RvXSlDL5j1HsufEI0ATG9tGT6oAXTOX60EVRC1QMc9r5A8JWeyptabq5jvX+kx/j5jIgK2CTYiI+q0R2qcOjrnqVXUS9bfUkEuZw== artur@status.im"
}
