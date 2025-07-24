terraform {
  backend "s3" {
    bucket = "test-london"
    key    = "tf-backend/state.tfstate"
    region = "eu-west-2"
  }
}