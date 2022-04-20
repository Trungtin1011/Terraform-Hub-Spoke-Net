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

variable "spoke1-address-space" {
    type = string
    description = "Address space for virtual network"
}

variable "spoke1-address-prefixes" {
    type = string
    description = "Address prefixes for azure subnet"
}

variable "spoke2-address-space" {
    type = string
    description = "Address space for virtual network"
}

variable "spoke2-address-prefixes" {
    type = string
    description = "Address prefixes for azure subnet"
}