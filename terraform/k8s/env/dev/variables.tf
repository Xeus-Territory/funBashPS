variable "environment" {
    type = string
    description = "environment of using this module"
    default = "dev"
}

variable "cluster_name" {
    type = string
    description = "Name of the cluster"
}

variable "cluster_resource_group" {
    type = string
    description = "Where the cluster is existence"
}