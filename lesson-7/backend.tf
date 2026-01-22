
terraform {
  backend "s3" {
    bucket         = "lesson-7-terraform-state-julia-387867038969"
    key            = "lesson-7/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "lesson-7-terraform-locks"
    encrypt        = true
  }
}
