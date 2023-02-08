
variable "environment" {
  type = string 
  description = "Enviroment name for working"
}

variable "tags" {
    type = map
    description = "Resource tags"
    default = null
}

variable "public_ip_orient" {
    type = string
    description = "The public IP Orient for specify config for blob"
    sensitive = true
}

variable "blob_name" {
    type = string
    description = "Name of Blob inside Container of Storage Account"
}