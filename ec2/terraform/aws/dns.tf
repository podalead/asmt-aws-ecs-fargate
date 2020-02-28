data "aws_route53_zone" "main" {
  name = var.dns_name
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.main.id
  name    = data.aws_route53_zone.main.name
  type    = "A"

  alias {
    name                   = module.elb.this_elb_dns_name
    zone_id                = module.elb.this_elb_zone_id
    evaluate_target_health = true
  }
}