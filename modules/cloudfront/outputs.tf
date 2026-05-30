output "cloudfront_domain_name" {
  value       = aws_cloudfront_distribution.this.domain_name
  description = "CloudFrontに割り当てられたデフォルトのドメイン名"
}
output "cloudfront_hosted_zone_id" {
  value       = aws_cloudfront_distribution.this.hosted_zone_id
  description = "CloudFrontのホストゾーンID（Route53のAlias設定用）"
}
