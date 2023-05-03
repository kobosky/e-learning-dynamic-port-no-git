# configure aws provider to establish a secure connection between terraform and aws
provider "aws" {
  region                  = var.region
  

  default_tags {
    tags = {
      "Automation"  = "teraform"
      "Project"     = var.project_name
      "Environment" = var.environment
    }
  }
} 
