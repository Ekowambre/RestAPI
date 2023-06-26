resource "aws_security_group" "ekow-SG" {
    description = "Allows API Access to SQS"
    egress      = [
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = ""
            from_port        = 80
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 80
        },
    ]
    vpc_id      = aws_vpc.ekow-vpc.id
    ingress     = []
    name        = "ekow-api-sqs-SG"

    tags        = {
        "Name" = "ekow-SG"
    }  
}
