terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = local.region
}

provider "random" {
}

resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
}

locals {
  region = "us-west-2"
  name   = "example-lambda"

  tags = {
    Name       = local.name
    Example    = "complete"
    Repository = "https://github.com/terraform-aws-modules/terraform-aws-lambda"
  }
}

################################################################################
# Lambda Module
################################################################################

module "lambda" {
  source = "../../"

  function_name = local.name
  description   = "Example Lambda function"
  handler       = "index.handler"
  runtime       = "nodejs18.x"
  publish       = true

  source_code_hash = data.archive_file.lambda_code.output_base64sha256
  filename         = data.archive_file.lambda_code.output_path

  memory_size = 256
  timeout     = 60

  environment_variables = {
    ENVIRONMENT = "example"
    LOG_LEVEL  = "INFO"
  }

  # VPC configuration
  vpc_subnet_ids         = module.vpc.private_subnets
  vpc_security_group_ids = [module.security_group.security_group_id]

  # CloudWatch logs
  cloudwatch_logs_retention_in_days = 14

  # Lambda Permissions
  lambda_permissions = {
    allow_s3 = {
      statement_id = "AllowS3Invoke"
      action       = "lambda:InvokeFunction"
      principal    = "s3.amazonaws.com"
      source_arn   = module.s3_bucket.s3_bucket_arn
    }
  }

  # Function URL
  create_function_url = true
  cors_allow_origins  = ["*"]
  cors_allow_methods  = ["POST", "GET"]
  cors_allow_headers  = ["date", "keep-alive"]

  # IAM role policies
  role_policies = {
    AWSLambdaBasicExecutionRole = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
    AWSLambdaVPCAccessExecutionRole = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  }

  tags = local.tags
}

################################################################################
# Supporting Resources
################################################################################

data "archive_file" "lambda_code" {
  type        = "zip"
  source_file = "${path.module}/src/index.js"
  output_path = "${path.module}/dist/function.zip"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = local.name
  cidr = "10.0.0.0/16"

  azs             = ["${local.region}a", "${local.region}b", "${local.region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = local.tags
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = local.name
  description = "Lambda security group"
  vpc_id      = module.vpc.vpc_id

  egress_rules = ["all-all"]

  tags = local.tags
}

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.0"

  bucket = "${local.name}-bucket-${random_string.random.result}"
  
  # Remove ACL configuration
  # acl    = "private"

  # Add ownership controls
  control_object_ownership = true
  object_ownership         = "BucketOwnerEnforced"

  versioning = {
    enabled = true
  }

  tags = local.tags
} 