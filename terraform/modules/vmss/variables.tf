variable "resource_group_root" {
  type = string 
  description = "Resource group Root"
}

variable "resource_group_name" {
  type = string
  description = "Resource group name of Dev Environment"
  default = "dev"
}

variable "resource_group_location" {
  type = string
  description = "Resource group location of Dev Environment"
  default = "southeastasia"
}


variable "environment" {
  type = string 
  description = "Enviroment name for working"
}

variable "tags" {
    type = map
    description = "Resource tags"
    default = null
}

variable "custom_emails" {
    type = string 
    description = "Custom Email to receive notification"
    default = "nguyen.nguyenhoaibao@orientsoftware.com"
}