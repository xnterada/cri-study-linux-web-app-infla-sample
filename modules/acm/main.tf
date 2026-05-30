# ACM証明書作成（DNS検証）
resource "aws_acm_certificate" "this" {
  domain_name       = var.domain_name
  validation_method = "DNS"
  # 複数のドメインを証明書に含める場合は、subject_alternative_namesを使用すること
  # subject_alternative_names = ["*.example.com", "api.example.com"]

  lifecycle {
    create_before_destroy = true
  }
}

# Route53検証用レコード作成（CNAMEレコード）
resource "aws_route53_record" "validation" {
  # SANで複数のサブドメインを含む証明書に対応するためループ（現状は1ドメインのみ想定）
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.zone_id
  # SANで複数ゾーンにまたがる場合は、zone_idを以下に差し替えること
  # zone_id = var.zone_ids[each.key]
}

# ACM証明書の検証完了を待機
resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}
