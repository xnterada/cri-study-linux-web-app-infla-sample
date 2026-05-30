variable "environment" {
  type        = string
  description = "環境名"
}

variable "project_name" {
  type        = string
  description = "プロジェクト名"
}

variable "domain_name" {
  type        = string
  description = "証明書を作成するドメイン名（例: example.com）"
}

variable "zone_id" {
  type        = string
  description = "DNS検証用レコードを作成するRoute53ホストゾーンID"
}

# SANで複数ゾーンにまたがるドメインを使う場合は、zone_idの代わりにこちらを使用すること
# variable "zone_ids" {
#   type        = map(string)
#   description = "ドメイン名をキーとしたホストゾーンIDのマップ（例: { \"example.com\" = \"Z1234...\" }）"
# }
