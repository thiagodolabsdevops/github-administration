
terraform {
  backend "s3" {
    bucket         = "labsdevops-terraform-state-bucket"
    key            = "github-administration/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
