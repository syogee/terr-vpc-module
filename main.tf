provider "aws" {
  region = "us-east-1"
}
module "vpc" {
  source = "./module/vpc"
  name = "cluster"
  vpc_cidr = "10.1.0.0/16"
  pub_subnet = [ "10.1.1.0/24" , "10.1.2.0/24" ]
  pri_subnet = [ "10.1.3.0/24" , "10.1.4.0/24" ]
}