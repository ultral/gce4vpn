resource "kubernetes_secret" "openvpn" {
  metadata {
    name = "openvpn-pki"
  }

  data = {
    "private.key" = var.openvpn_private_key
    "ca.crt" = var.openvpn_ca_crt
    "certificate.crt" = var.openvpn_certificate_crt
    "dh.pem" = var.openvpn_dh_pem
    "ta.key" = var.openvpn_ta_key
  }

  type = "Opaque"
}
