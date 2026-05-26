locals {
  # Decodifica o secret e extrai apenas a URL
  datadog_api_key = jsondecode(data.aws_secretsmanager_secret_version.pitflow.secret_string)["DATADOG_API_KEY"]
}