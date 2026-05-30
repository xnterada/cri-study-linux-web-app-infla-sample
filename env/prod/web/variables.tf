# ==============================================================================
# 変数定義 (Webレイヤー)
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

variable "cidr_block" {
  type        = string
  description = "VPCのCIDRブロック"
}

variable "aws_region" {
  type        = string
  description = "AWSリージョン"
  default     = "ap-northeast-1"
}

variable "availability_zone" {
  type        = string
  description = "サブネットを配置するアベイラビリティゾーン"
  default     = "ap-northeast-1a"
}

variable "ami" {
  type        = string
  description = "EC2インスタンスに使用するAMIのID"
}

variable "instance_type" {
  type        = string
  description = "EC2インスタンスのタイプ"
  default     = "t3.micro"
}

variable "terraform_state_bucket" {
  type        = string
  description = "Terraformリモートステート用のS3バケット名"
}

variable "terraform_state_cdn_key" {
  type        = string
  description = "CDNレイヤーのTerraformステートキー"
  default     = "prod/cdn/terraform.tfstate"
}

variable "deploy_public_key" {
  type        = string
  description = "deployユーザのSSH公開鍵"
}
