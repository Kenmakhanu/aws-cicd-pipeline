terraform{
    backend "s3" {
        bucket = "aws-cicdpipelinee"
        encrypt = true
        key = "terraform.tfstate"
        region = "us-west-2"
      
    }
}
