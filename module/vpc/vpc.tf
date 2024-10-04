#VPC

resource "aws_vpc" "EKS_VPC" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.name}-vpc"
  }
}

#IG

resource "aws_internet_gateway" "EKS_IG" {
  vpc_id = aws_vpc.EKS_VPC.id
  tags = {
    Name = "${var.name}-IG"
  }
}

# Public Subnets

resource "aws_subnet" "Public" {
  for_each = local.pub_subnet_map
  vpc_id = aws_vpc.EKS_VPC.id
  cidr_block = each.key
  availability_zone = element(local.azs_value,each.value)
  tags = {
    Name = "${var.name}-public subnet-${each.value + 1}"
  }
}

# Private Subnets

resource "aws_subnet" "Private" {
  for_each = local.pri_subnet_map
  vpc_id = aws_vpc.EKS_VPC.id
  cidr_block = each.key
  availability_zone = element(local.azs_value,each.value)
  tags = {
    Name = "${var.name}-Private subnet-${each.value + 1}"
  }
}

# Public Route table

resource "aws_route_table" "Public_RT" {
  vpc_id = aws_vpc.EKS_VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.EKS_IG.id
  }
  
  tags = {
    Name = "${var.name}-Public-RT"
  }
}

# Public Route table Association

resource "aws_route_table_association" "Public_RT_Association" {
  for_each = aws_subnet.Public
  subnet_id = each.value.id
  route_table_id = aws_route_table.Public_RT.id
}

#Elastic IP

resource "aws_eip" "Elastic_ip" {
  for_each = toset(var.pri_subnet)
  domain = "vpc"
}

#NAT gateway

resource "aws_nat_gateway" "NAT_GW" {
for_each = aws_subnet.Private
  allocation_id = aws_eip.Elastic_ip[each.key].id
  subnet_id = each.value.id
}

# Private Route table

resource "aws_route_table" "Private_RT" {
  for_each = aws_subnet.Private
  vpc_id = aws_vpc.EKS_VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NAT_GW[each.key].id
  }

  tags = {
    Name = "${var.name}-Private-RT"
  }
}

# Private Route table Association

resource "aws_route_table_association" "Private_RT_Association" {
  for_each = aws_subnet.Private
  subnet_id = each.value.id
  route_table_id = aws_route_table.Private_RT[each.key].id
}