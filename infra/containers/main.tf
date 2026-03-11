terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "= 0.9.4"
    }
  }
}

provider "libvirt" {
#  uri = "qemu:///system"
  uri = "qemu+ssh://root@${var.hypervisor}:22/system?keyfile=${var.private_key_path}"
}
