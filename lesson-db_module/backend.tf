
terraform {
  backend "s3" {
    bucket         = "lesson-db-module-terraform-state-julia-387867038969"
    key            = "lesson-db-module/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "lesson-db-module-terraform-locks"
    encrypt        = true
  }
}
