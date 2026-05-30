variable "project_name" {
  type        = string
  description = "プロジェクト名"
}

variable "environment" {
  type        = string
  description = "環境名"
}

variable "vpc_id" {
  type        = string
  description = "セキュリティグループを作成するVPCのID"
}

variable "subnet_id" {
  type        = string
  description = "インスタンスを配置するサブネットのID"
}

variable "ami" {
  type        = string
  description = "使用するAMIのID"
}

variable "instance_type" {
  type        = string
  description = "EC2インスタンスのタイプ"
}

variable "db_backup_bucket_arn" {
  type        = string
  description = "データベースバックアップ用S3バケットのARN"
}

variable "deploy_public_key" {
  type        = string
  description = "deployユーザのSSH公開鍵"
}
