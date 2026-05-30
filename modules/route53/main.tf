# プライマリレコード設定
resource "aws_route53_record" "failover_primary" {
  zone_id = var.zone_id
  name    = var.domain_name
  type    = "A"
  ttl     = "60"

  set_identifier = "primary"

  failover_routing_policy {
    type = "PRIMARY"
  }

  records = [var.primary_ip]

  health_check_id = var.health_check_id
}

# セカンダリレコード設定
resource "aws_route53_record" "failover_secondary" {
  zone_id = var.zone_id
  name    = var.domain_name
  type    = "A"

  set_identifier = "secondary"

  failover_routing_policy {
    type = "SECONDARY"
  }

  alias {
    name                   = var.secondary_alias_name
    zone_id                = var.secondary_alias_zone_id
    evaluate_target_health = true
  }
}
