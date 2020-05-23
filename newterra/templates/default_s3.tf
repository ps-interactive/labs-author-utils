resource "aws_s3_bucket" "s3_name" {
    bucket                      = "bucket_name"
    region                      = var.region
    request_payer               = "BucketOwner"
    tags                        = {}

    versioning {
        enabled    = false
        mfa_delete = false
    }
}