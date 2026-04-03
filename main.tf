module "network" {
  source = "./modules/network"
  region = var.region
}

module "compute" {
  source = "./modules/compute"
  region = var.region

  subnet_id         = module.network.public_subnet_id
  security_group_id = module.network.security_group_id


}

output "instance_public_ip" {
  value = module.compute.instance_public_ip
}

