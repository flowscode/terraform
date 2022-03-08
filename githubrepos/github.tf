terraform {
  required_providers {
    github = {
      source = "integrations/github"
      version = "~> 4.0"
    }
  }
}
provider "github" {
  token = var.githubtoken
}

resource "github_repository" "repo2" {
  name        = "RepoCreations"
  visibility = "public"

}

output "RepoCreations"{
  value = github_repository.repo2.html_url
}

resource "github_repository" "repo1" {
  name        = "EIPandEC2"
  visibility = "public"

}

output "EIPandEC2"{
  value = github_repository.repo1.html_url
}

resource "github_repository" "repo3" {
  name        = "IAM-USER"
  visibility = "public"

}

output "iamuser"{
  value = github_repository.repo3.html_url
}

resource "github_repository" "repo4" {
  name        = "conditional"
  visibility = "public"

}

output "conditional"{
  value = github_repository.repo4.html_url
}

resource "github_repository" "repo5" {
  name        = "local-values"
  visibility = "public"

}

output "local-values"{
  value = github_repository.repo5.html_url
}

resource "github_repository" "repo6" {
  name        = "terraform"
  visibility = "public"

}

output "terraform"{
  value = github_repository.repo6.html_url
}
