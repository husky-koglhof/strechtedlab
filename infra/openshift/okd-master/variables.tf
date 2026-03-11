variable "hypervisor" {
  type = string
}

variable "private_key_path" {
  type = string
}

variable vm_count {
  type = number
}

variable mac_list {
  type = list
}

variable internal_bridge {
  type = string
}