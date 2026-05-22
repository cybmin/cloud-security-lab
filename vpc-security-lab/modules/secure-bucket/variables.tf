variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "environment" {
  description = "The environment this bucket belongs to"
  type        = string
  default     = "dev"
}

variable "owner" {
  description = "The owner of this bucket"
  type        = string
}