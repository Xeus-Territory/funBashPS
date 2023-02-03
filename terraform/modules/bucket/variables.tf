variable "allowed_public_ip" {
    type = string
    description = "The public IP for specify config for blob"
    sensitive = true
}

variable "bucket_name" {
    type = string
    description = "Name of the bucket to create"
}