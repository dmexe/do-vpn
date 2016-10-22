resource "digitalocean_ssh_key" "openvpn" {
  name       = "Terraform"
  public_key = "${tls_private_key.user.public_key_openssh}"
}

resource "digitalocean_droplet" "openvpn" {
  image      = "ubuntu-16-04-x64"
  name       = "openvpn"
  region     = "ams2"
  size       = "512mb"
  ssh_keys   = ["${digitalocean_ssh_key.openvpn.id}"]
  user_data  = "${data.template_file.do_cloud_init.rendered}"
}
