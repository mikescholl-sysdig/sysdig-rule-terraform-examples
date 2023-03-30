terraform {
  backend "s3" {
    bucket = "mikescholl-sysdig-general"
    key    = "terraform"
    region = "us-west-2"
  }
}