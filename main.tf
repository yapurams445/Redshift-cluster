provider "aws" {
  region = var.vpc_region
}

// module "vpc" {
//   source = "./modules/vpc/"

//   vpc_name                = var.vpc_name
//   vpc_region              = var.vpc_region
//   availability_zone       = var.availability_zone
//   vpc_cidr_block          = var.vpc_cidr_block
//   vpc_public_subnet_cidr  = var.vpc_public_subnet_cidr
//   vpc_private_subnet_cidr = var.vpc_private_subnet_cidr

// }

module "redshift" {

  source = "./modules/redshift/"

  rs_cluster_identifier = var.rs_cluster_identifier
  rs_database_name = var.rs_cluster_type
  rs_master_username = var.rs_master_username
  rs_master_pass = var.rs_master_pass
  rs_nodetype = var.rs_nodetype
  rs_cluster_type = var.rs_cluster_type
  vpc_name = var.vpc_name
  availability_zone = var.availability_zone
  #vpc_region = var.vpc_region
}