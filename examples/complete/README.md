# Complete AWS Lambda Example

This example demonstrates usage of the AWS Lambda module with most of its supported features:

- Lambda function deployment from local file
- VPC configuration with private subnets
- Security group configuration
- CloudWatch Logs configuration
- Lambda Function URL with CORS
- IAM role with necessary permissions
- S3 bucket trigger configuration

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.0 |
| archive | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 4.0 |
| archive | >= 2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| lambda | ../../ | n/a |
| vpc | terraform-aws-modules/vpc/aws | ~> 5.0 |
| security_group | terraform-aws-modules/security-group/aws | ~> 5.0 |
| s3_bucket | terraform-aws-modules/s3-bucket/aws | ~> 3.0 |

## Resources

| Name | Type |
|------|------|
| [archive_file.lambda_code](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| lambda_function_arn | The ARN of the Lambda Function |
| lambda_function_name | The name of the Lambda Function |
| lambda_function_url | The URL of the Lambda Function URL |
| lambda_role_arn | The ARN of the IAM role created for the Lambda Function |
| cloudwatch_log_group_name | The name of the CloudWatch Log Group |
| vpc_id | The ID of the VPC |
| security_group_id | The ID of the security group |
| s3_bucket_id | The name of the S3 bucket | 