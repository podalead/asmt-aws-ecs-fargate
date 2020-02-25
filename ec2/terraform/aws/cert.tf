//provider "acme" {
//  server_url = "https://acme-v02.api.letsencrypt.org/directory"
//}
//
//resource "tls_private_key" "key" {
//  algorithm = "RSA"
//}
//
//resource "acme_registration" "reg" {
//  account_key_pem = tls_private_key.key.private_key_pem
//  email_address   = "podalead@gmail.com"
//
//  provider = acme
//}
//
//resource "acme_certificate" "certificate" {
//  account_key_pem           = acme_registration.reg.account_key_pem
//  common_name               = format("www.%s", var.dns_name)
////  common_name = var.dns_name
//
//  provider = acme
//
//  dns_challenge {
//    provider = "route53"
//  }
//}
//
//resource "aws_acm_certificate" "cert" {
//  private_key      = acme_certificate.certificate.private_key_pem
//  certificate_body = acme_certificate.certificate.certificate_pem
//  certificate_chain = acme_certificate.certificate.issuer_pem
//
//  lifecycle {
//    create_before_destroy = true
//  }
//}
//
//data "aws_acm_certificate" "cert" {
//  domain   = format("www.%s", var.dns_name)
////  domain = var.dns_name
//  statuses = ["ISSUED"]
//
//  depends_on = [ aws_acm_certificate.cert ]
//}