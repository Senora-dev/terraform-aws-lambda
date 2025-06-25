# AWS Lambda Terraform Module

This Terraform module creates and manages AWS Lambda functions with configurable runtime, handler, environment variables, and more.

## Features

- Create Lambda functions
- Support for multiple runtimes
- Environment variables
- IAM role and policy attachment
- VPC configuration
- Dead Letter Queue (DLQ) support
- Tagging support

## Usage

```hcl
module "lambda" {
  source = "Senora-dev/lambda/aws"

  function_name = "my-function"
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  s3_bucket     = "my-bucket"
  s3_key        = "lambda.zip"

  environment = {
    variables = {
      ENV = "dev"
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| function_name | Name of the Lambda function | `string` | n/a | yes |
| handler | Function entrypoint in your code | `string` | n/a | yes |
| runtime | Lambda runtime | `string` | n/a | yes |
| s3_bucket | S3 bucket storing Lambda code | `string` | n/a | yes |
| s3_key | S3 key for Lambda code | `string` | n/a | yes |
| environment | Environment variables | `map(string)` | `{}` | no |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| lambda_function_arn | The ARN of the Lambda function |
| lambda_function_name | The name of the Lambda function |

## Maintainers

This module is maintained by [Senora.dev](https://senora.dev). 