# ==============================================================================
# Route53 モジュールの変数定義ファイル
# ==============================================================================

variable "zone_id" {
  type        = string
  description = "DNS設定を管理するホストゾーンのID"
}

variable "domain_name" {
  type        = string
  description = "利用者のブラウザに入力されるドメイン名"
}

variable "primary_ip" {
  type        = string
  description = "接続先となるEC2のパブリックIPアドレス"
}

variable "health_check_id" {
  type        = string
  default     = null
  description = "フェイルオーバーの判断に使用するヘルスチェックのID"
}

variable "secondary_alias_name" {
  type        = string
  description = "切り替え先となるバックアップサイトのドメイン名"
}

variable "secondary_alias_zone_id" {
  type        = string
  description = "切り替え先ターゲットのRoute53ゾーンID"
}