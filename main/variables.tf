variable "rg-name" {
  type = string
  default = "RG_lab00_2022"
}

variable "subscription-id" {
  type = string
  description = "Subsctiption ID for the resource group"
  default = "cc50e71e-a3bc-40f0-bea2-075566983504"
}

variable "service-location" {
  type				= string
  description	= "Azure Region for resources. Defaults to Southeast Asia."
  default			= "Southeast Asia"
}

variable "tags" {
  type    = map(string)
  default = {
    Aim = "Infrastructure provision"
    Owner = "b.ngo@linkbynet.com"
    ModifyWith = "Terraform"
  }
}

variable "hub-environment" {
    type = string
    default = "hub"
    description = "Environment for module"
}

variable "spoke-environment" {
    type = string
    default = "spoke"
    description = "Environment for module"
}