data "aws_s3_bucket" "r3_london_bucket" {
  bucket = "test-london"
  provider = aws.london
}