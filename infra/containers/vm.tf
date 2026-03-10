resource "libvirt_volume" "services_volume" {
  pool   = "default"
  name   = "services-root"

  create = {
    content = {
      url = "images/image.qcow2"
    }
  }
}

data "template_file" "user_data" {
  template = templatefile("${path.module}/config/cloud_init.cfg",
  {
    hostname = var.hostname,
    domain_name = var.domain_name,
    user_name = var.user_name,
    ssh_key = var.ssh_key
  })
}

data "template_file" "network_config" {
  template = templatefile("${path.module}/config/network_config.cfg",
  {
    external_ip = var.external_ip,
    internal_ip = var.internal_ip,
    internal_gateway = var.internal_gateway,
    external_gateway = var.external_gateway,
    management_ip = var.management_ip,
    management_gateway = var.management_gateway,
    dns_server = var.dns_server
  })
}

resource "libvirt_cloudinit_disk" "cloud-init" {
  name           = "cloud-init-services-server.iso"
  user_data      = data.template_file.user_data.rendered
  network_config = data.template_file.network_config.rendered

  meta_data = <<-EOF
    instance-id: containers
    local-hostname: containers
  EOF
}

resource "libvirt_volume" "services_cloudinit" {
  name           = "cloud-init-services-server.iso"
  pool           = "default"
  # Format will be auto-detected as "iso"

  create = {
    content = {
      url = "/tmp/terraform-provider-libvirt-cloudinit/cloudinit-${libvirt_cloudinit_disk.cloud-init.id}.iso"
    }
  }
}

resource "libvirt_domain" "services_server" {
  name   = "Services"
  type = "kvm"
  memory = 8192 * 1024
  vcpu   = 4

  cpu = {
    mode = "host-passthrough"
  }

  os = {
    type    = "hvm"
    type_arch    = "x86_64"
    type_machine = "q35"
  }

  autostart = true

  devices = {
    graphics   = [
      {
        vnc = {
          auto_port = true
          listen    = "0.0.0.0"
        }
      },
    ]
    serials = [
      {
        type = "pty"
        target = {
          type = "isa-serial"
          # port = "0"
        }
      }
    ]
    consoles = [
      {
        type = "pty"
        target = {
          type = "serial"
          # port = "0"
        }
      }
    ]
    interfaces = [
      {
        model = {
          type = "virtio"
        },
        mac = {
          address = var.external_mac
        },
        source = {
          bridge = {
            bridge = var.external_bridge
          }
        }
      }, {
        model = {
          type = "virtio"
        },
        mac = {
          address = var.internal_mac
        },
        source = {
          bridge = {
            bridge = var.internal_bridge
          }
        }
      }, {
        model = {
          type = "virtio"
        },
        mac = {
          address = var.management_mac
        },
        source = {
          bridge = {
            bridge = var.management_bridge
          }
        }
      }
    ]
    disks = [
      {
        type = "file"
        device = "disk"
        source = {
          volume = {
            pool = libvirt_volume.services_volume.pool
            volume = libvirt_volume.services_volume.name
          }
        }
        target = {
          bus = "virtio"
          dev = "vda"
        }
        boot = {
            order = 1
        }
        driver = {
            type = "qcow2"
        }
      },
      {
        device = "cdrom"
        source = {
          volume = {
            pool   = libvirt_volume.services_cloudinit.pool
            volume = libvirt_volume.services_cloudinit.name
          }
        }
        target = {
          dev = "sda"
          bus = "sata"
        }
      }
    ]
  }
}
