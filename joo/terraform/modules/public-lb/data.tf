data "aws_acm_certificate" "amazon_issued" {
  domain      = "*.juiceb7597.com"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}
