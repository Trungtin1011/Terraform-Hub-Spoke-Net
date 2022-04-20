variable "rg_name" {
    type = string
}

variable "location" {
    type = string  
}

variable "environment" {
    type = string
}

variable "hub-name" {
    type = string
}

variable "vm-name" {
    type = string
}

variable "hub-address-space" {
    type = string
    description = "Address space for virtual network"
}

variable "hub-address-prefixes" {
    type = string
    description = "Address prefixes for azure subnet"
}