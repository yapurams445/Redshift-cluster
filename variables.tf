#variable "vpc_region" {}
#################################
######  VPC Vars
#################################
variable "availability_zone" {
  type        = list(string)
  description = "availability zone used for the demo, based on region"
}

########################### demo VPC Config ##################################

variable "vpc_name" {
  description = "VPC for building demos"
}

variable "vpc_region" { 
  description = "AWS region"
}

variable "vpc_cidr_block" {
  description = "Uber IP addressing for demo Network"
}

#Public Subnets
variable "vpc_public_subnet_cidr" {
  type = list(string)
  #default = ["10.20.1.0/24", "10.20.2.0/24"]
}

#Private Subnets
variable "vpc_private_subnet_cidr" {
  type = list(string)
  #default = ["10.20.1.0/24", "10.20.2.0/24"]
}

##########################################
########## Redshift Cluster
##########################################

variable "rs_cluster_identifier" {}
variable "rs_database_name" {}
variable "rs_master_username" {}
variable "rs_master_pass" {}
variable "rs_nodetype" {}
variable "rs_cluster_type" {}
// variable "vpc_name" {}
// variable "availability_zone" {}
// variable "vpc_region" {}
