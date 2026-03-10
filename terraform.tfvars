###################################################
#               GENERIC                           #
###################################################
internal_bridge = "stretched-int"
external_bridge = "stretched-ext"
management_bridge = "bridge0"

hypervisor = "10.0.11.10"
###################################################
#               ROUTER                            #  
###################################################
router_internal_mac = "c0:ff:ee:00:00:01"
router_external_mac = "fe:d4:a4:64:14:a8"

openshift_domain = "stretched.lcl"

###################################################
#               Containers                        #  
###################################################
containers_internal_mac = "c0:ff:ee:00:02:50"
containers_external_mac = "96:c2:0e:36:09:75"
containers_management_mac = "52:54:00:f7:2b:d9"

containers_internal_ip = "172.16.2.2"
containers_external_ip = "10.10.1.10"
containers_internal_subnet = "172.16.2.0/24"
containers_external_subnet = "10.10.1.0/24"
containers_internal_gateway = "172.16.2.1"
containers_external_gateway = "10.10.1.1"
containers_management_ip = "10.0.11.232"
containers_management_subnet = "10.0.11.0/24"
containers_management_gateway = "10.0.11.1"
containers_dns_server = "10.10.1.1"

containers_user_name = "christian"
containers_domain_name = "stretched.lcl"
containers_hostname = "containers"
containers_private_key_path = "/home/christian/.ssh/id_ed25519"
containers_ssh_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM9aIeuU4b3AZSjGs94iwmmatkGDPF9GXXUD+3VXZUT8 christian@hypervisor.home.lcl"

containers_internal_registry_address = "172.16.2.3"
containers_internal_quay_registry_address = "172.16.2.4"
containers_internal_docker_registry_address = "172.16.2.5"
containers_internal_k8s_registry_address = "172.16.2.6"
containers_internal_gcr_registry_address = "172.16.2.7"
containers_internal_ghcr_registry_address = "172.16.2.8"
containers_internal_openshift_ci_registry_address = "172.16.2.9"

###################################################
#               OpenShift                         #  
###################################################

os_bootstrap_internal_mac = "c0:ff:ee:00:00:11"

os_master_vm_count = 5
os_master_mac_list = [ "c0:ff:ee:00:00:12", "c0:ff:ee:00:00:13", "c0:ff:ee:00:00:14", "c0:ff:ee:00:00:15", "c0:ff:ee:00:00:16" ]

os_worker_vm_count = 5
os_worker_mac_list = [ "c0:ff:ee:00:00:17", "c0:ff:ee:00:00:18", "c0:ff:ee:00:00:19", "c0:ff:ee:00:00:20", "c0:ff:ee:00:00:21" ]
