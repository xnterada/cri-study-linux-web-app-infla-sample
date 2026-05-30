# ==============================================================================
# メイン設定ファイル (Webレイヤー)
# ==============================================================================

# AWSアカウント情報取得
data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

# CDNレイヤーのリモートステートを参照
data "terraform_remote_state" "cdn" {
  backend = "s3"
  config = {
    bucket = var.terraform_state_bucket
    key    = var.terraform_state_cdn_key
    region = var.aws_region
  }
}

# 1. ネットワーク(VPC)の構築
module "vpc" {
  source = "../../../modules/vpc"

  project_name      = var.project_name
  environment       = var.environment
  cidr_block        = var.cidr_block
  availability_zone = var.availability_zone
}

# 2. EC2インスタンス構築
module "ec2" {
  source = "../../../modules/ec2"

  project_name         = var.project_name
  environment          = var.environment
  vpc_id               = module.vpc.vpc_id
  subnet_id            = module.vpc.public_subnet_id
  ami                  = var.ami
  instance_type        = var.instance_type
  db_backup_bucket_arn = module.s3_db_backup.bucket_arn
  deploy_public_key    = var.deploy_public_key
}

# 3. データベース(SQLite)バックアップ用のS3バケット構築
module "s3_db_backup" {
  source = "../../../modules/s3"

  bucket_name = "${local.account_id}-${var.project_name}-${var.environment}-db-backup"
  environment = var.environment
}

# 4. Route53ヘルスチェックの設定
resource "aws_route53_health_check" "ec2" {
  ip_address        = module.ec2.public_ip
  port              = 80
  type              = "TCP"
  failure_threshold = "3"
  request_interval  = "30"
}

# 5. DNSレコード(フェイルオーバー)の設定
module "route53" {
  source = "../../../modules/route53"

  zone_id     = var.zone_id
  domain_name = var.domain_name

  # プライマリ（EC2インスタンスのパブリックIP）
  primary_ip = module.ec2.public_ip

  # セカンダリ（CDNレイヤーのCloudFrontドメイン名）
  secondary_alias_name    = data.terraform_remote_state.cdn.outputs.cloudfront_domain_name
  secondary_alias_zone_id = data.terraform_remote_state.cdn.outputs.cloudfront_hosted_zone_id

  health_check_id = aws_route53_health_check.ec2.id
}

# 6. 自動運用(Step Functions + Scheduler)の構築
module "sfn" {
  source = "../../../modules/sfn"

  project_name    = var.project_name
  environment     = var.environment
  instance_ids    = [module.ec2.instance_id]
  domain_name     = var.domain_name
  health_check_id = aws_route53_health_check.ec2.id
  hosted_zone_id  = var.zone_id
}
