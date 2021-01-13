variable dc-num {
  default = 0
}

variable dc-name {
  default = "dc1"
}

variable dc-role {
  type    = string
  default = "primary"
}

variable lxd-profile {
  type    = string
  default = "default"
}

variable vault-count {
  default = 3
}

variable license {
  type    = string
  default = ""
}
