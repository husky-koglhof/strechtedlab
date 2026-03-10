resource "libvirt_volume" "root" {
  name   = "root-okd-master${count.index+1}"
  pool   = "default"
  count = var.vm_count

  create = {
    content = {
      url = "images/coreos.qcow2"
    }
  }
}

resource "libvirt_ignition" "ignition" {
  name    = "ignition-okd-master${count.index+1}"
  content = file("openshift-generated/master.ign")
  count = var.vm_count
}

resource "libvirt_domain" "node" {
  count = var.vm_count
  name   = "okd-master${count.index+1}"
  type = "kvm"
  memory = "32768"
  vcpu   = 8
  autostart = false

  os = {
    type    = "hvm"
    type_arch    = "x86_64"
    type_machine = "q35"
  }

  cpu = {
    mode = "host-passthrough"
  }

  devices = {
    coreos_ignition = libvirt_ignition.ignition[count.index].id,
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
            mac = element(var.mac_list, count.index)
          }
        }
      }
    ],
    disk = [
      {
        source = {
          pool = libvirt_volume.root[count.index].pool
          volume = libvirt_volume.root[count.index].name
        }
        target = {
          bus = "virtio"
          dev = "vda"
        }
      }
    ]
  }
}
