resource "aws_vpc" "capstone-v" {
  cidr_block       = "80.80.0.0/16"

  tags = {
    Name = "aws_capstone-VPC"
  }
}

resource "aws_subnet" "public-a" {
  vpc_id     = aws_vpc.capstone-v.id
  cidr_block = "80.80.10.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "aws_capstone-public-subnet-1A"
  }
}

# resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
#   vpc_id     = aws_vpc.capstone-v.id
#   cidr_block = "80.80.0.0/16"
# }

# resource "aws_subnet" "in_secondary_cidr" {
#   vpc_id     = aws_vpc_ipv4_cidr_block_association.secondary_cidr.vpc_id
#   cidr_block = "80.80.10.0/24"
# }

resource "aws_subnet" "private-a" {
  vpc_id     = aws_vpc.capstone-v.id
  cidr_block = "80.80.11.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "aws_capstone-private-subnet-1A"
  }
}

resource "aws_subnet" "public-b" {
  vpc_id     = aws_vpc.capstone-v.id
  cidr_block = "80.80.20.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "aws_capstone-public-subnet-1B"
  }
}


resource "aws_subnet" "private-b" {
  vpc_id     = aws_vpc.capstone-v.id
  cidr_block = "80.80.21.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "aws_capstone-private-subnet-1B"
  }
}
     ### INTERNET GATEWAY ###
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.capstone-v.id

  tags = {
    Name = "aws_capstone-IGW"
  }
}

resource "aws_internet_gateway_attachment" "example" {
  internet_gateway_id = aws_internet_gateway.gw.id
  vpc_id              = aws_vpc.capstone-v.id
}



# resource "aws_instance" "foo" {
#   # ... other arguments ...

#   depends_on = [aws_internet_gateway.gw]
# }
 
      ###  ROUTE TABLE ###

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.capstone-v.id

  route {
    cidr_block = "0.0.0.0/0"
    instance_id = aws_instance.nat.id
  } 

  tags = {
    Name = "aws_capstone-private-RT"
  }
}


resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private-a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private-b.id
  route_table_id = aws_route_table.private.id
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.capstone-v.id
  # network_interface_id = aws_instance.nat.id
  route {
    cidr_block  = "0.0.0.0/0"
    gateway_id  = aws_internet_gateway.gw.id
  } 
 

  tags = {
    Name = "aws_capstone-public-RT"
  }
}

# resource "aws_route" "r" {
#   route_table_id            = aws_route_table.public.id
#   destination_cidr_block    = "0.0.0.0/0"
#   network_interface_id               = aws_instance.nat.id
#   depends_on                = [aws_route_table.public]
# }
  


resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public-a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public-b.id
  route_table_id = aws_route_table.public.id
}


# output "aws_route_table_public_ids" {
#   value = aws_route_table.public.id
# }


# resource "aws_route" "public_internet_gateway" {
#   route_table_id         = aws_route_table.public.id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.gw.id
# }

   ###  ENDPOINT   ###
 
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.capstone-v.id
  service_name = "com.amazonaws.us-east-1.s3"
 

  tags = {
    Environment = "aws-capstone-endpoint"
  }
}

resource "aws_vpc_endpoint_route_table_association" "example" {
  route_table_id  = aws_route_table.private.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}



# resource "aws_instance" "foo" {
#   # ... other arguments ...

#   depends_on = [aws_internet_gateway.gw]
# }