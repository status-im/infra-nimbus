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
    for zone in data.cloudflare_zones.active.zones:
      zone.name => zone.id
  }
}

/* ACCESS KEY ------------------------------------------------------*/

resource "aws_key_pair" "jakubgs" {
  key_name   = "jakubgs"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDA6mutbRHO8VvZ61MYvjIVv1Re9NiJGE1piTQq4IFwXOvAi1HkXkMlsjmzYt+CEv0HmMGCHmdrw5xpqnDTWg18lM5RYLzrAv9hBOQ10IC+8FH2XWDKoyz+PBQsNEbbJ23QQtu0O5mpsOzI/KBT9CkiYUYlEBwHI0vNqsdHDLwv3Yt7PhauguXDHpYnwH/OseVHLBg2+/3aJIfOMVVRnhptQGYAhTNUZ9F1EwvQETMhM/vEsk8+o9B3tK/Ii/RD2EtVUlpRG4q6QTFbssLMImUfcdoggHsfCqjq3apUs8bR81oN9UVoYiP8tn5sWIUyRBxIEzXpqa4rx04KY8xNYqeZ jakub@status.im"
}

resource "aws_key_pair" "arthurk" {
  key_name   = "arthurk"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCrYtuXQi7TkyGVsXtd81LyOLihMHpZFZnArrNn8m90lOmohSwD8pSgX+Lhw+yEguSgnBhYIDWxDzZqGHIMXquCwwK6Kv4RT+IpwX9m5yMUJbReLAe5NbjX3thGkd9+wHFqpHnO7bzLuKeNqyYdm6I8/l3e4P6fG7NOvDReSX4lNoSZpOJD9pmzxH1rv4kI/NfKxhm88rpZ2D6Nx2k9Eep3KjVYTIUFTre98eoV/4USrAB0Mj8nHqA/i0nTni2pf8rBYp0xlLik91+k2skLrHgfUi4LuzEkudGYZPdDSC1qrsB6qjmO0z6lEyYIUpr9My7vANKT9MT5VKsNJomATChlD1x3THjW++2aQ+XXHYkmTqKixPzJiB1D8SWBKnEI1wjKadv2J8RuTBPeybtBfuY3Mqj9U2xrp7Rr3l/ciiSk+z2v3HGW4XFtaMpmOc69sghE9nu+0lEEkA7o+Xlml2PUdPfFPmO3G1PRcK9v/Fyz6BPMZhaDCiENS6IhapsuNAUiEp8FriocAInd/UKlJyH+ydZ9d/ivQ3XaMuOr6AOpbwO+MZEPEGJG051+SFyXUWaN6xWQx2cAgSgF4yjbZpeIfkOoOdIu9BDmCR3rD0L4W4RxBTop8OJ+eZaGNvdk8T0Ty5/tlxmL1tKjktlPjMFv2Nr/laTmUyLuKefQlW1Y4w== arthur@status.im"
}
