
variable "environment" {
  type = string 
  description = "Enviroment name for working"
}

variable "tags" {
    type = map
    description = "Resource tags"
    default = null
}

variable "allowed_ips" {
    type = string
    description = "The ip allow access storage blob"
    sensitive = true
}

variable "blob_name" {
    type = string
    description = "Name of Blob inside Container of Storage Account"
}