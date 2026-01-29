# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "lks_bucket" {
  bucket = "my-tf-test-bucket"

  tags = {
    Name = "lks-orders-deri-2026"
  }
}