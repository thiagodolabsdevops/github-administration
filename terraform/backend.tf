
terraform {
  backend "s3" {
    bucket         = "labsdevops-terraform-state-bucket"
    key            = "github-administration/terraform.tfstate" # TODO: Make it dynamic through variables in CI/CD pipeline
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
