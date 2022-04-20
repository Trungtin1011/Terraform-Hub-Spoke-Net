module "rg" {
    source = "../../modules/rg"
    resource_group_name = var.rg_name
    location = var.service-location
}

module "hub" {
    source = "../../modules/hub"
    resource_group_name = module.rg.resource_group_name
    location = var.service-location
    environment = var.hub-environment
    hub-name = "LEP-HUB"
    hub-address-space = "10.0.0.0/24"
    hub-address-prefixes = "10.0.0.0/24"
    subnet-id = module.hub.hub-address-prefixes
}

module "spokes" {
    source = "../../modules/spokes"
    resource_group_name = var.rg_name
    location = var.service-location
    environment = var.environment
    hub-name = "LEP-HUB"
    spoke-name = "LEP-SPOKE"
    subnet-id = module.spokes.spoke1-address-prefixes
}

