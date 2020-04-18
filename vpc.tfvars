vpc_region        = "eu-west-1"
availability_zone = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
vpc_name          = "datascience-gb-vpc"
vpc_cidr_block    = "10.230.0.0/16"
#public Subnets
vpc_public_subnet_cidr = ["10.230.0.0/20", "10.230.16.0/20", "10.230.32.0/20"]
#Private Subnets
vpc_private_subnet_cidr = ["10.230.112.0/20", "10.230.128.0/20", "10.230.144.0/20"]

