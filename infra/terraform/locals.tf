locals {
  platform_values = jsondecode(data.aws_secretsmanager_secret_version.pitflow.secret_string)

  datadog_api_key = local.platform_values.DATADOG_API_KEY
  load_balancer_url = trimsuffix(
    try(local.platform_values.LB_URL, "http://pending-first-deploy"),
    "/"
  )
}
