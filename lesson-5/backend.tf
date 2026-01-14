terraform {
  backend "s3" {
    bucket         = "lesson-5-terraform-state-julia-387867038969"
    key            = "lesson-5/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "lesson-5-terraform-locks"
    encrypt        = true
  }
}
