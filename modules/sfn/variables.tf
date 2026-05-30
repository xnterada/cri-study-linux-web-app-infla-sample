variable "project_name" {
  type        = string
  description = "リソース名に付与するプロジェクト識別子"
}

variable "environment" {
  type        = string
  description = "環境名"
}

variable "instance_ids" {
  type        = list(string)
  description = "自動起動・停止の対象となるEC2インスタンスIDのリスト"
}

variable "domain_name" {
  type        = string
  description = "Route53に登録するドメイン名"
}

variable "health_check_id" {
  type        = string
  description = "Route53ヘルスチェックのID"
}

variable "hosted_zone_id" {
  type        = string
  description = "Route53ホストゾーンのID"
}
