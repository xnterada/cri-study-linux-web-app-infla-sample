# OAC (Origin Access Control) 作成
resource "aws_cloudfront_origin_access_control" "this" {
  name                              = "${var.project_name}-${var.environment}-cloudfront-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# CloudFrontディストリビューション作成
resource "aws_cloudfront_distribution" "this" {
  comment = "${var.project_name}-${var.environment}-cloudfront-distribution"

  origin {
    domain_name              = var.s3_origin_domain_name
    origin_id                = "S3Origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
  }

  enabled             = true
  default_root_object = "index.html" # ドメイン名だけでアクセスした際に表示するファイル

  aliases = var.aliases

  # デフォルトのキャッシュ動作
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3Origin"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https" # HTTPアクセスを強制的にHTTPSにリダイレクト
  }

  # 地理的制限の設定
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # 証明書設定
  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}

# S3バケットポリシー設定（CloudFront (OAC) からのみS3アクセスを許可）
resource "aws_s3_bucket_policy" "this" {
  bucket = var.s3_bucket_id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "s3:GetObject"
        Effect   = "Allow"
        Resource = "arn:aws:s3:::${var.s3_bucket_id}/*"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.this.arn
          }
        }
      }
    ]
  })
}
