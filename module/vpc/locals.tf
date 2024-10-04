locals{
    pub_subnet_map = zipmap(tolist(var.pub_subnet),range(length(var.pub_subnet)))
    pri_subnet_map = zipmap(tolist(var.pri_subnet),range(length(var.pri_subnet)))
    azs_value = length(var.azs) > 0 ? var.azs : data.aws_availability_zones.available.names
}