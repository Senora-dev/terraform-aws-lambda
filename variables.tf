variable "create_function" {
  description = "Controls whether Lambda Function should be created"
  type        = bool
  default     = true
}

variable "filename" {
  description = "Path to the function's deployment package within the local filesystem"
  type        = string
  default     = null
}

variable "s3_bucket" {
  description = "S3 bucket location containing the function's deployment package"
  type        = string
  default     = null
}

variable "s3_key" {
  description = "S3 key of an object containing the function's deployment package"
  type        = string
  default     = null
}

variable "s3_object_version" {
  description = "Object version containing the function's deployment package"
  type        = string
  default     = null
}

variable "source_code_hash" {
  description = "Used to trigger updates when file contents change"
  type        = string
  default     = null
}

variable "image_uri" {
  description = "ECR image URI containing the function's deployment package"
  type        = string
  default     = null
}

variable "package_type" {
  description = "Lambda deployment package type"
  type        = string
  default     = "Zip"
}

variable "function_name" {
  description = "Unique name for your Lambda Function"
  type        = string
}

variable "handler" {
  description = "Function entrypoint in your code"
  type        = string
  default     = null
}

variable "runtime" {
  description = "Lambda Function runtime"
  type        = string
  default     = null
}

variable "publish" {
  description = "Whether to publish creation/change as new Lambda Function Version"
  type        = bool
  default     = false
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime"
  type        = number
  default     = 128
}

variable "timeout" {
  description = "Amount of time your Lambda Function has to run in seconds"
  type        = number
  default     = 3
}

variable "reserved_concurrent_executions" {
  description = "Amount of reserved concurrent executions for this lambda function"
  type        = number
  default     = -1
}

variable "layers" {
  description = "List of Lambda Layer Version ARNs to attach to your Lambda Function"
  type        = list(string)
  default     = null
}

variable "environment_variables" {
  description = "Map of environment variables that are accessible from the function code during execution"
  type        = map(string)
  default     = {}
}

variable "vpc_subnet_ids" {
  description = "List of subnet IDs associated with the Lambda function"
  type        = list(string)
  default     = null
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs associated with the Lambda function"
  type        = list(string)
  default     = null
}

variable "dead_letter_target_arn" {
  description = "ARN of an SNS topic or SQS queue to notify when an invocation fails"
  type        = string
  default     = null
}

variable "tracing_mode" {
  description = "X-Ray tracing mode"
  type        = string
  default     = "PassThrough"
}

variable "create_role" {
  description = "Controls whether IAM role for Lambda Function should be created"
  type        = bool
  default     = true
}

variable "role_arn" {
  description = "Existing IAM role ARN for the Lambda Function. Required if create_role is false"
  type        = string
  default     = null
}

variable "role_name" {
  description = "Name of IAM role to use for Lambda Function"
  type        = string
  default     = null
}

variable "role_description" {
  description = "Description of IAM role to use for Lambda Function"
  type        = string
  default     = null
}

variable "role_path" {
  description = "Path of IAM role to use for Lambda Function"
  type        = string
  default     = null
}

variable "role_max_session_duration" {
  description = "Maximum session duration (in seconds) for IAM role"
  type        = number
  default     = 3600
}

variable "role_permissions_boundary" {
  description = "ARN of the policy that is used to set the permissions boundary for the IAM role"
  type        = string
  default     = null
}

variable "role_policies" {
  description = "Map of IAM policies to attach to IAM role"
  type        = map(string)
  default     = {}
}

variable "lambda_permissions" {
  description = "Map of Lambda permissions to create"
  type        = map(any)
  default     = {}
}

variable "create_cloudwatch_log_group" {
  description = "Controls whether CloudWatch log group for Lambda Function should be created"
  type        = bool
  default     = true
}

variable "cloudwatch_logs_retention_in_days" {
  description = "Specifies the number of days you want to retain log events"
  type        = number
  default     = null
}

variable "cloudwatch_logs_kms_key_id" {
  description = "The ARN of the KMS Key to use when encrypting log data"
  type        = string
  default     = null
}

variable "create_function_url" {
  description = "Controls whether Lambda Function URL should be created"
  type        = bool
  default     = false
}

variable "function_url_authorization_type" {
  description = "The type of authentication that the function URL uses. Valid values are: NONE and AWS_IAM"
  type        = string
  default     = "NONE"
}

variable "cors_allow_credentials" {
  description = "Whether to allow cookies or other credentials in requests to the function URL"
  type        = bool
  default     = false
}

variable "cors_allow_origins" {
  description = "The origins that can access the function URL"
  type        = list(string)
  default     = ["*"]
}

variable "cors_allow_methods" {
  description = "The HTTP methods that are allowed when calling the function URL"
  type        = list(string)
  default     = ["*"]
}

variable "cors_allow_headers" {
  description = "The HTTP headers that are allowed when calling the function URL"
  type        = list(string)
  default     = ["*"]
}

variable "cors_expose_headers" {
  description = "The HTTP headers in your function response that you want to expose to viewers"
  type        = list(string)
  default     = []
}

variable "cors_max_age" {
  description = "The maximum amount of time, in seconds, that web browsers can cache results of a preflight request"
  type        = number
  default     = 0
}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {}
}

variable "description" {
  description = "Description of the Lambda function"
  type        = string
  default     = null
} 