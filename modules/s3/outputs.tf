output "bucket_name" {
  value       = aws_s3_bucket.this.id
  description = "作成されたS3バケットの名前"
}

output "bucket_arn" {
  value       = aws_s3_bucket.this.arn
  description = "作成されたS3バケットのARN"
}

output "bucket_regional_domain_name" {
  value       = aws_s3_bucket.this.bucket_regional_domain_name
  description = "S3のリージョン別ドメイン名"
}
