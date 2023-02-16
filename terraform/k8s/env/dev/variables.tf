variable "environment" {
    type = string
    description = "environment of using this module"
}

variable "clusterName" {
    type = string
    description = "Name of the cluster"
}

variable "clusterRG" {
    type = string
    description = "Where the cluster is existence"
}