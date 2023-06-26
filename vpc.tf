resource "aws_vpc" "ekow-vpc" {
    assign_generated_ipv6_cidr_block     = false
    cidr_block                           = "172.31.0.0/16"
    enable_dns_hostnames                 = false
    enable_dns_support                   = true
    instance_tenancy                     = "default"
  
    tags = {
        "Name" = "Ekow-vpc"
    }
}

resource "aws_subnet" "ekow-subnet-a" {
    availability_zone                              = "eu-west-2a"
    cidr_block                                     = "172.31.0.0/20"
    vpc_id                                         = aws_vpc.ekow-vpc.id
   
    tags = {
        "Name" = "ekow-subnet-a"
    } 
}

resource "aws_subnet" "ekow-subnet-b" {
    availability_zone                              = "eu-west-2b"
    cidr_block                                     = "172.31.16.0/20"
    vpc_id                                         = aws_vpc.ekow-vpc.id

    tags = {
        "Name" = "ekow-subnet-b"
    }
}

resource "aws_subnet" "ekow-subnet-c" {
    availability_zone                              = "eu-west-2c"
    cidr_block                                     = "172.31.32.0/20"
    vpc_id                                         = aws_vpc.ekow-vpc.id

    tags                                           = {
        "Name" = "ekow-subnet-c"
    }
}

resource "aws_vpc_endpoint" "ekow-endpoint" {

    policy                = jsonencode(
        {
            Statement = [
                {
                    Action    = "*"
                    Effect    = "Allow"
                    Principal = "*"
                    Resource  = "*"
                },
            ]
        }
    )
    private_dns_enabled   = false
    route_table_ids       = []
    security_group_ids    = [
        aws_security_group.ekow-SG.id,
    ]
    service_name          = "com.amazonaws.eu-west-2.execute-api"
    subnet_ids            = [
        aws_subnet.ekow-subnet-a.id,
        aws_subnet.ekow-subnet-b.id,
        aws_subnet.ekow-subnet-c.id,
    ]
    tags                  = {}
    tags_all              = {}
    vpc_endpoint_type     = "Interface"
    vpc_id                = aws_vpc.ekow-vpc.id

    dns_options {
        dns_record_ip_type = "ipv4"
    }
}
