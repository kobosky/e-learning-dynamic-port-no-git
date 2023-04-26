# store the terraform state file in s3 and lock with dynamodb
terraform {
  backend "s3" {
    bucket                   = "elearning-terraform-state"
    key                      = "terraform-module/e-learning/terraform.tfstate"
    region                   = "eu-west-2"
    shared_credentials_files = ["C:/Users/Kobosky/.aws/credentials"]
    dynamodb_table           = "terraform-state-lock"
  }
}