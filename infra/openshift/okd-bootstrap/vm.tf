resource "libvirt_volume" "root" {
  pool   = "default"
  name   = "root-okd-bootstrap"

  create = {
    content = {
      url = "images/coreos.qcow2"
    }
  }
}

resource "libvirt_ignition" "ignition" {
  name    = "ignition-okd-bootstrap"
  content = file("openshift-generated/bootstrap.ign")
}


resource "libvirt_volume" "ignition" {
  name   = "bootstrap.ign"
  pool   = "default"
  format = "raw"

  create = {
    content = {
      url = libvirt_ignition.ignition.path
    }
  }
}

resource "libvirt_domain" "bootstrap" {
  name   = "okd-bootstrap"
  type = "kvm"
  memory = 16 * 1024 * 1024
  vcpu   = 4

  sys_info = [ 
    {
      fw_cfg = {
        entry = [
          {
            name = "opt/com.coreos/config"
            file = "/var/lib/libvirt/images/bootstrap.ign"
            value = ""
          }
        ]
      }
    }
  ]
  os = {
    type    = "hvm"
    type_arch    = "x86_64"
    type_machine = "q35"
    boot = {
      dev = "hd"
    }
  }

  
  cpu = {
    mode = "host-passthrough"
  }

  devices = {
    coreos_ignition = libvirt_ignition.ignition.id,
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
        source = {
          bridge = {
            bridge = var.internal_bridge
            mac = var.internal_mac
          }
        }
      }
    ],
    disks = [
      {
        type = "file"
        device = "disk"
        source = {
          volume = {
            pool = libvirt_volume.root.pool
            volume = libvirt_volume.root.name
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
      # {
      #   device = "cdrom"
      #   source = {
      #     volume = {
      #       pool = libvirt_volume.ignition.pool
      #       volume = libvirt_volume.ignition.name
      #     }
      #   }
      #   target = {
      #     dev = "sda"
      #     bus = "sata"
      #   }
      # }
    ]
  }
}
