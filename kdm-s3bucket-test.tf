terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
}

    backend "s3" {
    bucket  = "jenkins-321528232261-us-east-2-an"
    key     = "jenkins/jenkins-s3-kdm.tfstate"
    region  = "us-east-2"
    encrypt = true

    }

}

provider "aws" {

  region = "us-east-2"

}

resource "aws_s3_object" "armageddon-proof-png" {

  bucket = "jenkins-321528232261-us-east-2-an"
  key    = "armageddon-pass-email.png"
  source = "./armageddon-pass-email.png"
  etag   = filemd5("./Armageddon_Pass.png")
  content_type = "image/png"

}

resource "aws_s3_object" "armageddon-repo-link" {

  bucket  = "jenkins-321528232261-us-east-2-an"
  key     = "armageddon-repo-link.txt"
  content = "Greetings! Here is the link for the Brotherhood of Steel's Armageddon Repo. : https://github.com/Brotherhood-Of-Steel-Cloud-AI-DevOps/BOS-ARMAGEDDON-LABS-1-3"
  etag    = filemd5("./armageddon-repo-link.txt")
  content_type = "text/plain"
}
