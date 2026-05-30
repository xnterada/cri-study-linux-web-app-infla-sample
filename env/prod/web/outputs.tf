# ==============================================================================
# 出力定義ファイル（Webレイヤー）
# ==============================================================================

output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "構築されたVPCのID"
}

output "ec2_instance_id" {
  value       = module.ec2.instance_id
  description = "構築されたEC2インスタンスのID"
}

output "ec2_public_ip" {
  value       = module.ec2.public_ip
  description = "構築されたEC2サーバーのパブリックIPアドレス"
}