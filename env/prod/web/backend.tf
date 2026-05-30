# ==============================================================================
# バックエンド設定 (Webレイヤー)
# ==============================================================================

terraform {
  backend "s3" {
    bucket = "{ACCOUNT_ID}-cri-study-linux-terraform-state"
    key    = "prod/web/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
