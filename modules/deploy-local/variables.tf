variable "name" {
  type = string
}
variable "region" {
  type = string
}
variable "src" {
  type = string
}

variable "output_zip_path" {
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
