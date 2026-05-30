variable "project_name" {
  type        = string
  description = "プロジェクト名"
}

variable "environment" {
  type        = string
  description = "環境名"
}

variable "cidr_block" {
  type        = string
  description = "VPCのCIDRブロック"
}

variable "availability_zone" {
  type        = string
  description = "サブネットを配置するAZ"
}
