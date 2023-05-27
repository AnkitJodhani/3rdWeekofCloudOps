# Get the certificate from AWS ACM
data "aws_acm_certificate" "issued" {
  domain   = var.CERTIFICATE_DOMAIN_NAME
  statuses = ["ISSUED"]
}



#creating Cloudfront distribution :
resource "aws_cloudfront_distribution" "my_distribution" {
  enabled             = true
  aliases             =  [var.ADDITIONAL_DOMAIN_NAME]
  origin {
    domain_name = var.ALB_DOMAIN_NAME
    origin_id   = var.ALB_DOMAIN_NAME
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = var.ALB_DOMAIN_NAME
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      headers      = []
      query_string = true
      cookies {
        forward = "all"
      }
    }
  }
  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["IN", "US", "CA"]
    }
  }
  tags = {
    Name = var.PROJECT_NAME
  }
  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.issued.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }
}