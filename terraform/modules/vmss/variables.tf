
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