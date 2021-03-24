resource "aws_s3_bucket" "codepipeline-artifact" {
    bucket = "pipeline-artifact-ken"
    acl    = "private"

}