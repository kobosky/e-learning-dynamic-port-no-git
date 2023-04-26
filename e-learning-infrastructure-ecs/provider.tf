# configure aws provider to establish a secure connection between terraform and aws
provider "aws" {
  region                  = var.region
  shared_credentials_file = ["C:/Users/Kobosky/.aws/credentials"]

  default_tags {
    tags = {
      "Automation"  = "teraform"
      "Project"     = var.project_name
      "Environment" = var.environment
    }
  }
} 