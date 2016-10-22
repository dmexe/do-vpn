resource "tls_private_key" "ca" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "ca" {
  key_algorithm         = "RSA"
  private_key_pem       = "${tls_private_key.ca.private_key_pem}"
  is_ca_certificate     = true
  validity_period_hours = 8760 # 1 year

  subject {
    common_name = "example.com"
    organization = "ACME Examples, Inc"
  }

  allowed_uses = [
  ]
}
