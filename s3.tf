resource "aws_s3_bucket" "lesson7-bucket" {
  bucket = "lesson7-bucket"
  acl    = "public-read-write"

  tags = {
    Name        = "lesson7-bucket"
  }
}