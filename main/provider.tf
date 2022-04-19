terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.2"
    }
  }
#   backend "azurerm" {
#     resource_group_name   = """
#     storage_account_name = ""
#     container_name = ""
#     access_key = ""
# }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = "54d87296-b91a-47cd-93dd-955bd57b3e9a"
}