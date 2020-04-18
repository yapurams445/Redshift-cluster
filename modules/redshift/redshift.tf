provider "aws" {
  region = var.vpc_region
}

data "aws_vpc" "selected" {
  tags = {
    Name = var.vpc_name
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.selected.id
  tags = {
    Name = "Public-Subnet-*"
  }
}



// data "aws_subnet" "subnets" {
//   // count = length(data.aws_subnet_ids.public.ids)
//   // id = element(data.aws_subnet_ids.public.ids, count.index)

//   for_each = data.aws_subnet_ids.id
//   id = each.value
// }

resource "aws_default_security_group" "redshift_security_group" {
  vpc_id = data.aws_vpc.selected.id
  ingress {
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "redshift-sg"
  }
}

// resource "aws_redshift_subnet_group" "redshift-subnet-group"{
//   for_each = data.aws_subnet_ids.public.ids
//   subnet_ids = each.value
//   name = "redshift-subnet-group"
// }

resource "aws_redshift_subnet_group" "redshift-subnet-group" {
  name = "redshift-subnet-group"
  count = length(data.aws_subnet_ids.public.ids)
  #subnet_ids = ["subnet-00fb46b5bec0d47e3", "subnet-07b084ec2b46a23bb", "subnet-044fc97154e45a6eb"]
  #subnet_ids = ["${split(",", data.aws_subnet_ids.public.id)}"]
  subnet_ids = tolist(data.aws_subnet_ids.public.ids)[count.index]
  #subnet_ids = "${element(data.aws_subnet_ids.public, 0)}"
  #subnet_ids = ["${data.aws_subnet_ids.public.[0].id}"]
  #subnet_ids = 
  #  subnet_ids = ["${aws_subnet.redshift_subnet_1.id}", "${aws_subnet.redshift_subnet_2.id}"]
  tags = {
    environment = "dev"
    Name        = "redshift-subnet-group"
  }
}

resource "aws_redshift_cluster" "default" {
  cluster_identifier = var.rs_cluster_identifier
  #count = length(aws_redshift_subnet_group.rsg)
  #number-of_nodes    = var.required_nodes
  #availability_zone  = var.availability_zone
  database_name             = var.rs_database_name
  master_username           = var.rs_master_username
  master_password           = var.rs_master_pass
  node_type                 = var.rs_nodetype
  cluster_type              = var.rs_cluster_type
  cluster_subnet_group_name = aws_redshift_subnet_group.redshift-subnet-group.id
  skip_final_snapshot       = true
  # iam_roles = ["${aws_iam_role.redshift_role.arn}"]
}

// resource "aws_iam_role" "redshift_role" {
//   name = "redshift_role"
//   assume_role_policy = <<EOF
//     {
//         "Version": "2012-10-17",
//         "Statement": [
//             {
//             "Action": "sts:AssumeRole",
//             "Principal": {
//                 "Service": "redshift.amazonaws.com"
//             },
//             "Effect": "Allow",
//             "Sid": ""
//         }
//     ]
//     }
//     EOF
//   tags = {
//         tag-key = "redshift-role"
//     }
// }
