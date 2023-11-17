data "aws_route53_zone" "selected" {
  name = "juiceb7597.com."
}

data "aws_lb_hosted_zone_id" "main" {
  region = "ap-northeast-2"
}