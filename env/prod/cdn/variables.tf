# ==============================================================================
# 変数定義 (CDNレイヤー)
# ==============================================================================

variable "project_name" {
  type        = string
  description = "プロジェクト名"
  default     = "cri-study-linux"
}

variable "environment" {
  type        = string
  description = "環境名"
  default     = "prod"
}

variable "domain_name" {
  type        = string
  description = "ドメイン名"
}

variable "zone_id" {
  type        = string
  description = "Route53ホストゾーンのID"
}
