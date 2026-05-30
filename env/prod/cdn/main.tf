# ==============================================================================
# メイン設定ファイル (CDNレイヤー)
# ==============================================================================

# AWSアカウント情報取得
data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

# 1. SSL/TLS証明書(ACM)の作成
module "acm" {
  source = "../../../modules/acm"

  project_name = var.project_name
  environment  = var.environment
  domain_name  = var.domain_name
  zone_id      = var.zone_id
}

# 2. フェイルオーバー用静的サイトのS3バケット構築
module "s3_failover" {
  source = "../../../modules/s3"

  bucket_name = "${local.account_id}-${var.project_name}-${var.environment}-failover-site"
  environment = var.environment
}

# 3. CloudFrontディストリビューションの構築
module "cloudfront" {
  source = "../../../modules/cloudfront"

  project_name          = var.project_name
  environment           = var.environment
  aliases               = [var.domain_name]
  acm_certificate_arn   = module.acm.cert_arn
  s3_origin_domain_name = module.s3_failover.bucket_regional_domain_name
  s3_bucket_id          = module.s3_failover.bucket_name
}
