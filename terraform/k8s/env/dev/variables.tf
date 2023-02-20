variable "environment" {
    type = string
    description = "environment of using this module"
    default = "dev"
}

variable "cluster_name" {
    type = string
    description = "Name of the cluster"
    default = "dev-k8s"
}

variable "cluster_resource_group" {
    type = string
    description = "Where the cluster is existence"
    default = "dev-environment"
}