resource "aws_lambda_function" "this" {
  count = var.create_function ? 1 : 0

  filename         = var.filename
  s3_bucket       = var.s3_bucket
  s3_key          = var.s3_key
  s3_object_version = var.s3_object_version
  source_code_hash = var.source_code_hash
  image_uri       = var.image_uri
  package_type    = var.package_type

  function_name = var.function_name
  description   = var.description
  role          = var.create_role ? aws_iam_role.this[0].arn : var.role_arn
  handler       = var.handler
  runtime       = var.runtime
  publish       = var.publish

  memory_size                    = var.memory_size
  timeout                        = var.timeout
  reserved_concurrent_executions = var.reserved_concurrent_executions
  layers                        = var.layers

  dynamic "environment" {
    for_each = length(keys(var.environment_variables)) > 0 ? [true] : []

    content {
      variables = var.environment_variables
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_subnet_ids != null && var.vpc_security_group_ids != null ? [true] : []

    content {
      subnet_ids         = var.vpc_subnet_ids
      security_group_ids = var.vpc_security_group_ids
    }
  }

  dynamic "dead_letter_config" {
    for_each = var.dead_letter_target_arn != null ? [true] : []

    content {
      target_arn = var.dead_letter_target_arn
    }
  }

  tracing_config {
    mode = var.tracing_mode
  }

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "this" {
  count = var.create_function && var.create_cloudwatch_log_group ? 1 : 0

  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = var.cloudwatch_logs_retention_in_days
  kms_key_id        = var.cloudwatch_logs_kms_key_id

  tags = var.tags
}

resource "aws_iam_role" "this" {
  count = var.create_function && var.create_role ? 1 : 0

  name                  = var.role_name != null ? var.role_name : var.function_name
  description           = var.role_description
  path                 = var.role_path
  max_session_duration = var.role_max_session_duration
  permissions_boundary = var.role_permissions_boundary

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = { for k, v in var.role_policies : k => v if var.create_function && var.create_role }

  role       = aws_iam_role.this[0].name
  policy_arn = each.value
}

resource "aws_lambda_permission" "this" {
  for_each = var.create_function ? var.lambda_permissions : {}

  statement_id  = lookup(each.value, "statement_id", each.key)
  action        = lookup(each.value, "action", "lambda:InvokeFunction")
  function_name = aws_lambda_function.this[0].function_name
  principal     = each.value.principal
  source_arn    = lookup(each.value, "source_arn", null)
}

resource "aws_lambda_function_url" "this" {
  count = var.create_function && var.create_function_url ? 1 : 0

  function_name      = aws_lambda_function.this[0].function_name
  authorization_type = var.function_url_authorization_type

  cors {
    allow_credentials = var.cors_allow_credentials
    allow_origins     = var.cors_allow_origins
    allow_methods     = var.cors_allow_methods
    allow_headers     = var.cors_allow_headers
    expose_headers    = var.cors_expose_headers
    max_age          = var.cors_max_age
  }
} 