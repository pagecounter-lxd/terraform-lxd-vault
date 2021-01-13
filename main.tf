locals {
  vault-map = zipmap(lxd_container.vault.*.id, lxd_container.vault.*.ipv4_address)
}

terraform {
  required_providers {
    lxd = {
      source = "terraform-lxd/lxd"
      version = "1.5.0"
    }
  }
}

resource "lxd_container" "vault" {
  count     = var.vault-count
  name      = "${format("vault%02d", count.index + 1)}-${var.dc-role}"
  image     = "packer-vault"
  ephemeral = false
  profiles  = [var.lxd-profile]

  config = {
    "user.user-data" = templatefile("${path.module}/cloud-init.tpl", {
      dc            = var.dc-name,
      iface         = "eth0",
      consul_server = "consul01-${var.dc-role}",
      cluster_name  = var.dc-role,
      license = var.license
      }
    )
  }

  device {
    name = "vault"
    type = "proxy"
    properties = {
      "connect" = "tcp:127.0.0.1:8200",
      "listen"  = "tcp:0.0.0.0:${8200 + count.index + var.dc-num * 10}"
    }
  }

}

output "hosts" {
  value = local.vault-map
}
