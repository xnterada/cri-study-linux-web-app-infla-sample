output "vpc_id" {
  value       = aws_vpc.this.id
  description = "作成されたVPCのID"
}

output "public_subnet_id" {
  value       = aws_subnet.public.id
  description = "作成されたパブリックサブネットのID"
}
