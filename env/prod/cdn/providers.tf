# ==============================================================================
# プロバイダー設定 (CDNレイヤー)
# ==============================================================================

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
    }
  }
}
