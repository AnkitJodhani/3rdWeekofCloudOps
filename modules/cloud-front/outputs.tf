
output "CLOUDFRONT_DOMAIN_NAME" {
  value = aws_cloudfront_distribution.my_distribution.domain_name
}

output "CLOUDFRONT_ID" {
  value = aws_cloudfront_distribution.my_distribution.id
}

output "CLOUDFRONT_ARN" {
  value = aws_cloudfront_distribution.my_distribution.arn
}


output "CLOUDFRONT_STATUS" {
  value = aws_cloudfront_distribution.my_distribution.status
}

output "CLOUDFRONT_HOSTED_ZONE_ID" {
  value = aws_cloudfront_distribution.my_distribution.hosted_zone_id
}