terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.10.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.1.1"
    }
  }
}
