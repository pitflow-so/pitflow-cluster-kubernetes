resource "aws_apigatewayv2_api" "pitflow" {
  name          = "${var.project_name}-api-gateway"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda_auth" {
  api_id           = aws_apigatewayv2_api.pitflow.id
  integration_type = "AWS_PROXY"
  integration_uri  = data.aws_lambda_function.auth.invoke_arn
}

resource "aws_apigatewayv2_route" "auth_post" {
  api_id    = aws_apigatewayv2_api.pitflow.id
  route_key = "POST /auth/customer"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_auth.id}"
}

resource "aws_apigatewayv2_integration" "lambda_budget" {
  api_id           = aws_apigatewayv2_api.pitflow.id
  integration_type = "AWS_PROXY"
  integration_uri  = data.aws_lambda_function.budget_form.invoke_arn
}

resource "aws_apigatewayv2_route" "budget_get" {
  api_id    = aws_apigatewayv2_api.pitflow.id
  route_key = "GET /customer/budget"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_budget.id}"
}

resource "aws_apigatewayv2_route" "budget_post" {
  api_id    = aws_apigatewayv2_api.pitflow.id
  route_key = "POST /customer/budget/confirm"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_budget.id}"
}

resource "aws_apigatewayv2_integration" "eks_backend" {
  api_id             = aws_apigatewayv2_api.pitflow.id
  integration_type   = "HTTP_PROXY"
  integration_uri    = local.load_balancer_url
  integration_method = "ANY"

  request_parameters = {
    "overwrite:path" = "$request.path.proxy"
  }
}

resource "aws_apigatewayv2_route" "eks_proxy" {
  api_id    = aws_apigatewayv2_api.pitflow.id
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.eks_backend.id}"
}

resource "aws_apigatewayv2_route" "root" {
  api_id    = aws_apigatewayv2_api.pitflow.id
  route_key = "ANY /"
  target    = "integrations/${aws_apigatewayv2_integration.eks_backend.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.pitflow.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_lambda_permission" "api_gateway_auth" {
  statement_id  = "AllowExecutionFromPitflowApiGateway"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.auth.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.pitflow.execution_arn}/*/*"
}

resource "aws_lambda_permission" "api_gateway_budget" {
  statement_id  = "AllowExecutionFromPitflowApiGateway"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.budget_form.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.pitflow.execution_arn}/*/*"
}
