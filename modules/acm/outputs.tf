output "cert_arn" {
  value       = aws_acm_certificate.this.arn
  description = "発行されたACM証明書のARN"
}

output "cert_domain_validation_options" {
  value       = aws_acm_certificate.this.domain_validation_options
  description = "ACM証明書のドメイン検証オプション (DNSレコード情報)"
}
