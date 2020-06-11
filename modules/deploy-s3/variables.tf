variable "name" {
  type = string
}
variable "region" {
  type = string
}
variable "bucket" {
  type = string
}
variable "upload_name" {
  type = string
}
variable "lambdavars" {
  type = map
}

variable "memory_size" {
  type = number
  default = 128
}

variable "timeout" {
  type = number
  default = 10
}
