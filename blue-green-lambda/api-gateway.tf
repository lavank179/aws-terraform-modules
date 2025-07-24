resource "aws_api_gateway_rest_api" "test-api" {
  name = "${local.common_tags.environment}-rest-api"
  tags = local.common_tags
}

resource "aws_api_gateway_resource" "test-resource" {
  rest_api_id = aws_api_gateway_rest_api.test-api.id
  parent_id   = aws_api_gateway_rest_api.test-api.root_resource_id
  path_part   = "${local.common_tags.environment}-resource"
}

resource "aws_api_gateway_method" "test-method" {
  rest_api_id   = aws_api_gateway_rest_api.test-api.id
  resource_id   = aws_api_gateway_resource.test-resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "api-gw-integration" {
  rest_api_id             = aws_api_gateway_rest_api.test-api.id
  resource_id             = aws_api_gateway_resource.test-resource.id
  http_method             = aws_api_gateway_method.test-method.http_method
  type                    = "AWS_PROXY"
  integration_http_method = "POST"
  uri                     = aws_lambda_alias.lavan-blue-green.invoke_arn
}

resource "aws_api_gateway_deployment" "test-deployment" {
  rest_api_id = aws_api_gateway_rest_api.test-api.id
  depends_on  = [aws_api_gateway_integration.api-gw-integration]

  # triggers = {
  #   redeployment = timestamp()
  # }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "gateway-stage" {
  deployment_id = aws_api_gateway_deployment.test-deployment.id
  rest_api_id   = aws_api_gateway_rest_api.test-api.id
  stage_name    = "default"
}

data "aws_lambda_function" "test_lambda-invoker" {
  function_name = aws_lambda_function.test_lambda.function_name
  qualifier     = aws_lambda_alias.lavan-blue-green.name
}

resource "aws_lambda_permission" "for_base_function" {
  statement_id  = "AllowBaseFunction"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.test-api.execution_arn}/*/*/*"
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowAlias"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.test_lambda.function_name}:${aws_lambda_alias.lavan-blue-green.name}"
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "${aws_api_gateway_rest_api.test-api.execution_arn}/*/*/*"
}
