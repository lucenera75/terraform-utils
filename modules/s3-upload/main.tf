variable "name" {
  type = string
}
variable "upload_name" {
  type = string
}
variable "region" {
  type = string
}
variable "src" {
  type = string
}
variable "output_path" {
  type = string
}
variable "bucket" {
  type = string
}
provider "aws" {
  version = "~> 2.0"
  region  = var.region
}

data "aws_s3_bucket" "lambdas" {
  bucket = var.bucket
}

data "archive_file" "init" {
  type        = "zip"
  source_dir  = var.src
  output_path = "${var.output_path}/${var.name}.zip"
}

resource "aws_s3_bucket_object" "src" {
  bucket = data.aws_s3_bucket.lambdas.id
  key    = "${var.name}/${var.upload_name}"
  source = "${var.output_path}/${var.name}.zip"

  tags = {
    hash = filebase64sha256("${var.output_path}/${var.name}.zip")
  }
}