# ==============================================================================
# CDNレイヤーの出力定義
# ==============================================================================

output "cloudfront_domain_name" {
  value       = module.cloudfront.cloudfront_domain_name
  description = "CloudFrontのデフォルトドメイン名"
}

output "cloudfront_hosted_zone_id" {
  value       = module.cloudfront.cloudfront_hosted_zone_id
  description = "CloudFrontのホストゾーンID"
}

output "failover_bucket_name" {
  value       = module.s3_failover.bucket_name
  description = "フェイルオーバー用静的サイトのS3バケット名"
}

output "cert_domain_validation_options" {
  value       = module.acm.cert_domain_validation_options
  description = "ACM証明書のドメイン検証オプション (DNSレコード情報)"
}