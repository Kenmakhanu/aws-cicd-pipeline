resource "aws_codebuild_project" "tf-plan" {
  name          = "tf-cicd-plan"
  description   = "plan stage for terraform"
  service_role  = aws_iam_role.tf-codebuild-role.arn

  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "hashicorp/terraform:0.14.4"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "SERVICE_ROLE"
    registry_credential {
        credential = var.dockerhub_credentials
        credential_provider = "SECRETS_MANAGER"
    }
  }

 source {
    type   = "CODEPIPELINE"
    buildspec = file("buildspec/plan-buildspec.yml")
 }
 
}

resource "aws_codebuild_project" "tf-apply" {
  name          = "tf-cicd-apply"
  description   = "Apply stage for terraform"
  service_role  = aws_iam_role.tf-codebuild-role.arn

  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "hashicorp/terraform:0.14.4"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "SERVICE_ROLE"
    registry_credential {
        credential = var.dockerhub_credentials
        credential_provider = "SECRETS_MANAGER"
    }
  }
source  {
    type   = "CODEPIPELINE"
    buildspec = file("buildspec/apply-buildspec.yml")
  }
}

# Build the pipeline
resource "aws_codepipeline" "cicd-pipeline"{
  name     = "tf-cicd"
  role_arn = aws_iam_role.tf-codepipeline-role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline-artifact.id
    type     = "S3"
  }
    
  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      output_artifacts = ["tf-code"]
      version          =  "1"
      configuration = {
        ConnectionArn    = var.codestar_connector_credentials
        FullRepositoryId = "Kenmakhanu/aws-cicd-pipeline"
        BranchName       = "main"
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }

  stage {
    name = "PLAN"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["tf-code"]
      version          = "1"
      configuration = {
        ProjectName = "tf-cicd-plan"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Build"
      provider        = "CodeBuild"
      owner            = "AWS"
      input_artifacts = ["tf-code"]
      version         = "1"
      configuration = {
        ProjectName    = "tf-cicd-appy"
        
      }
    }
  }
}
