output "bucket_id" {
  value = aws_s3_bucket.s3_bucket.id
}

output "example" {
  value = local.local_example
}

output "london_bucket_id" {
  value = data.aws_s3_bucket.r3_london_bucket.id
}

output "random" {
  value = random_string.random_string
}