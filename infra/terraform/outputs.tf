output "api_gateway_endpoint" {
  description = "Public base URL of the shared PitFlow API Gateway."
  value       = aws_apigatewayv2_api.pitflow.api_endpoint
}
