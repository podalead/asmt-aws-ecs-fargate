module "alb" {
  source                        = "terraform-aws-modules/alb/aws"
  log_location_prefix           = "my-alb-logs"
  subnets                       = module.vpc.public_subnets
  tags                          = map("Environment", var.profile)
  vpc_id                        = module.vpc.vpc_id
  http_tcp_listeners            = list(map("port", "80",  "protocol", "HTTP"))
  https_listeners               = list(map("port", "443", "protocol", "HTTPS", "certificate_arn",data.aws_acm_certificate.cert.arn))
  security_groups               = [ aws_security_group.egress.id, aws_security_group.proxy.id ]

  target_groups                 = [
    {
      name             = "https",
      backend_protocol = "HTTPS",
      backend_port     = "443",
      health_check     = {
        enabled             = true
        interval            = "10"
        path                = var.health_check
        port                = "80"
        healthy_threshold   = "3"
        unhealthy_threshold = "9"
        timeout             = "3"
        protocol            = "HTTPS"
      }
    }
  ]
}

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

data "aws_acm_certificate" "cert" {
  domain = var.dns_name
  statuses = ["ISSUED"]
  most_recent = true
}