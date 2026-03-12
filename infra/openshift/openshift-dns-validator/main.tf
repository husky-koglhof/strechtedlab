resource "terraform_data" "generate-openshift-generated" {
  provisioner "local-exec" {
    interpreter = [ "bash", "-ceu"]
    command = <<-EOL
        nslookup registry.${var.domain}
        nslookup quay.${var.domain}
        nslookup registry-1.${var.domain}
        nslookup registry-k8s.${var.domain}
        nslookup gcr.${var.domain}
        nslookup ghcr.${var.domain}
        nslookup openshift-ci.${var.domain}
        nslookup api.openshift.${var.domain}
        nslookup api-int.openshift.${var.domain}
        nslookup *.apps.openshift.${var.domain}
        nslookup bootstrap.openshift.${var.domain}
        nslookup master1.openshift.${var.domain}
        nslookup master2.openshift.${var.domain}
        nslookup master3.openshift.${var.domain}
        nslookup master4.openshift.${var.domain}
        nslookup master5.openshift.${var.domain}
        nslookup worker1.openshift.${var.domain}
        nslookup worker2.openshift.${var.domain}
        nslookup worker3.openshift.${var.domain}
        nslookup worker4.openshift.${var.domain}
        nslookup worker5.openshift.${var.domain}
        nslookup worker6.openshift.${var.domain}
        nslookup worker7.openshift.${var.domain}
    EOL
  }
}
