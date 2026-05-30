output "instance_id" {
  value       = aws_instance.this.id
  description = "作成されたEC2インスタンスのID"
}
output "public_ip" {
  value       = aws_instance.this.public_ip
  description = "作成されたEC2のパブリックのIPアドレス"
}
