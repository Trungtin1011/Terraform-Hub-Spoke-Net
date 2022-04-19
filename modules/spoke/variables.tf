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

variable "spoke-name" {
    type = string
}

variable "spoke-address-space" {
    type = string
    description = "Address space for virtual network"
}

variable "spoke-address-prefixes" {
    type = string
    description = "Address prefixes for azure subnet"
}