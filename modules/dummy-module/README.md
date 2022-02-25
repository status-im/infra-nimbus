# Description

This is a dummy module which does not create any actual cloud resources. It's intended for registering hosts which cannot be managed with Terraform to our infra.

For example providers like Hetzner or MacStadium have no provider module for Terrafom.

This module creates the Ansible inventory hosts in order to make hosts appear the same way all the other hosts created by Terraform do.
