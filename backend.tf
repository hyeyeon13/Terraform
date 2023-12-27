# S3 버킷을 생성한다
resource "aws_s3_bucket" "for_tfstate" {
  bucket = "hy-terraform-tfstate-change-2"
}
# S3 버킷의 버저닝 기능 활성화 선언한다.
resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.for_tfstate.bucket

  versioning_configuration {
    status = "Enabled"
  }
}

# DynamoDB for terraform state lock
resource "aws_dynamodb_table" "terraform_state_lock" {
  name         = "terraform-lock"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}

// Backend
terraform {
  required_version = ">= 0.12"
  backend "s3" {
    region         = "ap-northeast-2"
    # bucket         = "${var.project_name}-${var.account_name}-terraform-state"
    # key            = "${var.project_name}-${var.account_name}-terraform.tfstate"
    # dynamodb_table = "${var.project_name}_${var.account_name}_terraform_lock"
    bucket         = "hy-terraform-tfstate-change-1"
    key            = "hy-terraform.tfstate"
    dynamodb_table = "hy_terraform_lock"
    #encrypt = true
  }
} 