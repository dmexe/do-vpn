variable "openvpn_ta_file"       { default = "./secrets/openvpn-ta.key" }
variable "openvpn_conf_file"     { default = "./secrets/openvpn.conf" }
variable "openvpn_ip_addr"       { default = "172.19.93.1" }
variable "openvpn_ip_mask"       { default = "255.255.255.0" }
variable "openvpn_ip_pool"       { default = "172.19.93.10 172.19.93.199 255.255.255.0"}
variable "openvpn_dns_server"    { default = "172.19.93.1" }
variable "openvpn_image"         { default = "kylemanna/openvpn" }
variable "dnsmasq_image"         { default = "andyshinn/dnsmasq:2.75" }

output "user_key" {
  value = "${tls_private_key.user.private_key_pem}"
}

output "do_droplet" {
  value = "${digitalocean_droplet.openvpn.ipv4_address}"
}

output "openvpn_ip_addr" {
  value = "${var.openvpn_ip_addr}"
}

output "openvpn_ca_pem" {
  value = "${tls_self_signed_cert.ca.cert_pem}"
}

output "openvpn_client_pem" {
  value = "${tls_locally_signed_cert.client.cert_pem}"
}

output "openvpn_client_key" {
  value = "${tls_private_key.client.private_key_pem}"
}
