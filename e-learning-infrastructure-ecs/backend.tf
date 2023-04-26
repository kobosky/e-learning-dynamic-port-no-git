# store the terraform state file in s3 and lock with dynamodb
terraform {
  backend "s3" {
    bucket         = "elearning-terraform-state"
    key            = "terraform-module/e-learning/terraform.tfstate"
    region         = "eu-west-2"
    profile        = "my_aws_profile"
    dynamodb_table = "terraform-state-lock"
  }
}