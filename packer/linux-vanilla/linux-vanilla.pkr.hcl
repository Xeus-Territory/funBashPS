variable "os_type" {
    type = string
    default = "Linux"
}

variable "publisher" {
    type = string
    default = "Canonical"
}

variable "offer" {
    type = string
    default = "UbuntuServer"
}

variable "sku" {
    type = string
    default = "18.04-LTS"
}

variable "version" {
    type = string
    default = "latest"
}

variable "render_image_name" {
    type = string
}

variable "resource_managed_image_name" {
    type = string
    default = "DevOpsIntern"
}

variable "location" {
    type = string
    default = "southeastasia"
}

variable "vm_size" {
    type = string
    default = "Standard_B1s"
}

variable "tags" {
    type = map(string)
    default = {
        managed = "packer"
        environment = "dev"
    }
}

variable "communicator" {
    type = string
    default = "ssh"
}

source "azure-arm" "linux-vanilla" {
    use_azure_cli_auth = true
    os_type = var.os_type
    image_publisher = var.publisher
    image_offer = var.offer
    image_sku = var.sku
    image_version = var.version
    managed_image_name = var.render_image_name
    managed_image_resource_group_name = var.resource_managed_image_name

    location = var.location
    vm_size = var.vm_size
    azure_tags = var.tags
    communicator = var.communicator
}

build {
    sources = ["source.azure-arm.linux-vanilla"]

    provisioner "shell" {
        script = "${dirname(abspath(path.root))}/script/setup-az.sh" 
    }
}