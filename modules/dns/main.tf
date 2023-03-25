#############################################
## DNS MODULE
#############################################

data "aws_route53_zone" "primary" {
  name = var.route53_zone_name
  private_zone = false
}

resource "aws_route53_record" "route53_record" {
  count = length(var.route53_dns_records)

  zone_id         = data.aws_route53_zone.primary.id
  name            = var.route53_dns_records[count.index]["name"]
  type            = var.route53_dns_records[count.index]["type"]
  ttl             = var.route53_dns_records[count.index]["ttl"]
  records         = var.route53_records_value
  allow_overwrite = var.route53_allow_record_overwrite
  
}

resource "aws_route53_record" "www" {
  depends_on = [
    aws_route53_record.route53_record
  ]
  count = length(var.route53_dns_records)

  zone_id = data.aws_route53_zone.primary.id
  name    = var.route53_alias_name
  type    = var.route53_alias_type

  alias {
    name                   = var.route53_dns_records[count.index]["name"]
    zone_id                = data.aws_route53_zone.primary.id
    evaluate_target_health = false
  }
}
