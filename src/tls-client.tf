resource "tls_private_key" "client" {
  algorithm = "RSA"
}

resource "tls_cert_request" "client" {
  key_algorithm   = "RSA"
  private_key_pem = "${tls_private_key.client.private_key_pem}"

  subject {
    common_name = "me@example.com"
    organization = "VPN Client"
  }
}

resource "tls_locally_signed_cert" "client" {
  cert_request_pem      = "${tls_cert_request.client.cert_request_pem}"

  ca_key_algorithm      = "RSA"
  ca_private_key_pem    = "${tls_private_key.ca.private_key_pem}"
  ca_cert_pem           = "${tls_self_signed_cert.ca.cert_pem}"

  validity_period_hours = 8760

  allowed_uses = [
    "digital_signature",
    "client_auth"
  ]
}
