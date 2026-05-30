# ==============================================================================
# バックエンド設定 (CDNレイヤー)
# ==============================================================================

terraform {
  backend "s3" {
    bucket = "{ACCOUNT_ID}-cri-study-linux-terraform-state"
    key    = "prod/cdn/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
