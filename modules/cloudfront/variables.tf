variable "project_name" {
  type        = string
  description = "プロジェクト名"
}

variable "environment" {
  type        = string
  description = "環境名"
}

variable "s3_origin_domain_name" {
  type        = string
  description = "オリジンとなるS3バケットのドメイン名"
}

variable "aliases" {
  type        = list(string)
  default     = []
  description = "CloudFrontに関連付ける独自ドメイン（CAME名）のリスト"
}

variable "acm_certificate_arn" {
  type        = string
  description = "CloudFrontで使用するACM証明書のARN"
}

variable "s3_bucket_id" {
  type        = string
  description = "アクセスを許可するS3バケットID"
}
