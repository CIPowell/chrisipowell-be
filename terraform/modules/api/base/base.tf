data "aws_route53_zone" "zone" {
    name = "chrisipowell.co.uk."
    private_zone = false
}

resource "aws_apigatewayv2_api" "api" {
    name = "cipapi"
    protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "prod" { 
  api_id = aws_apigatewayv2_api.api.id
  name = "prod"

  auto_deploy = true

  lifecycle {
    ignore_changes = [deployment_id, default_route_settings]
  }
}

resource "aws_apigatewayv2_domain_name" "api_domain" { 
    domain_name = "api.chrisipowell.co.uk"

    domain_name_configuration {
        certificate_arn = aws_acm_certificate.api_cert.arn
        endpoint_type = "REGIONAL"
        security_policy = "TLS_1_2"
    }
}

resource "aws_acm_certificate" "api_cert" { 
    domain_name = "api.chrisipowell.co.uk"

    validation_method = "DNS"

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_route53_record" "api_cert_validation" {
    name = aws_acm_certificate.api_cert.domain_validation_options.0.resource_record_name
    type = aws_acm_certificate.api_cert.domain_validation_options.0.resource_record_type
    zone_id = data.aws_route53_zone.zone.zone_id
    records = [aws_acm_certificate.api_cert.domain_validation_options.0.resource_record_value]
    ttl = 60
}


resource "aws_acm_certificate_validation" "api_cert" {
    certificate_arn = aws_acm_certificate.api_cert.arn
    validation_record_fqdns = [aws_route53_record.api_cert_validation.fqdn]
}

resource "aws_apigatewayv2_api_mapping" "api_mapping"{
    api_id = aws_apigatewayv2_api.api.id
    domain_name = aws_apigatewayv2_domain_name.api_domain.id
    stage = aws_apigatewayv2_stage.prod.id
}

resource "aws_cloudwatch_log_group" "api_access_log" {
    name = "api_logs"
}

output "api_gateway_id" {
    value = aws_apigatewayv2_api.api.id
}

output "api_gateway_execution_arn" { 
    value = aws_apigatewayv2_api.api.execution_arn
}