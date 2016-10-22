data "template_file" "openvpn_conf" {
  template = "${file("${var.openvpn_conf_file}")}"

  vars {
    openvpn_ip_addr       = "${var.openvpn_ip_addr}"
    openvpn_ip_mask       = "${var.openvpn_ip_mask}"
    openvpn_ip_pool       = "${var.openvpn_ip_pool}"
    openvpn_dns_server    = "${var.openvpn_dns_server}"
  }
}

data "template_file" "do_cloud_init" {
  template = "${file("${path.module}/files/do-cloud-init.yml")}"

  vars {
    openvpn_conf          = "${base64encode(data.template_file.openvpn_conf.rendered)}"
    openvpn_ca_pem        = "${base64encode(tls_self_signed_cert.ca.cert_pem)}"
    openvpn_server_pem    = "${base64encode(tls_locally_signed_cert.server.cert_pem)}"
    openvpn_server_key    = "${base64encode(tls_private_key.server.private_key_pem)}"
    openvpn_ta_key        = "${base64encode(file(var.openvpn_ta_file))}"
    openvpn_ip_addr       = "${var.openvpn_ip_addr}"
    openvpn_ip_mask       = "${var.openvpn_ip_mask}"
    openvpn_image         = "${var.openvpn_image}"
    dnsmasq_image         = "${var.dnsmasq_image}"
  }
}
