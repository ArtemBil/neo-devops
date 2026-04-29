terraform {
  backend "s3" {
    bucket         = "artembilko-terraform-state"
    key            = "lesson-8/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
