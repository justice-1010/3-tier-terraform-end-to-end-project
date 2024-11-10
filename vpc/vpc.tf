resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-main-vpc"
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-igw"
  })
}

resource "aws_subnet" "frontend_subnent_1" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.public_cidr_block[0]
  availability_zone = var.availability_zone[1]

 tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-frontend-subnet-1"
  })
}


resource "aws_subnet" "frontend_subnent_2" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.public_cidr_block[1]
  availability_zone = var.availability_zone[1]

 tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-frontend-subnet-2"
  })
}


resource "aws_subnet" "backend_subnent_1" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.private_cidr_block[0]
  availability_zone = var.availability_zone[0]

 tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-backend-subnet-1"
  })
}


resource "aws_subnet" "backend_subnent_2" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.private_cidr_block[1]
  availability_zone = var.availability_zone[1]

 tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-backend-subnet-2"
  })
}

resource "aws_subnet" "db_subnent_3" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.private_cidr_block[2]
  availability_zone = var.availability_zone[0]

 tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-db-subnet-3"
  })
}

resource "aws_subnet" "db_subnent_4" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = var.private_cidr_block[3]
  availability_zone = var.availability_zone[1]

 tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-db-subnet-4"
  })
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }


  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-public-rt"
  })
}


resource "aws_route_table_association" "frontend_subnent_1" {
  subnet_id      = aws_subnet.frontend_subnent_1.id
  route_table_id = aws_route_table.public_rt.id
}


resource "aws_route_table_association" "frontend_subnent_2" {
  subnet_id      = aws_subnet.frontend_subnent_2.id
  route_table_id = aws_route_table.public_rt.id
}


resource "aws_eip" "eip" {
  instance = aws_instance.web.id
  domain   = "vpc"


  
  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-eip"
  })
}



resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.frontend_subnent_1.id


 tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-nat-gw"
  })

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_eip.eip,aws_subnet.frontend_subnent_1.id ]
}

  


resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }


  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private-rt"
  })
}


resource "aws_route_table_association" "backend_subnent_1" {
  subnet_id      = aws_subnet.backend_subnent_1
  route_table_id = aws_route_table.private_rt
}


resource "aws_route_table_association" "backend_subnent_1" {
  subnet_id      = aws_subnet.db_subnent_3.id
  route_table_id = aws_route_table.private_rt.id
}



resource "aws_eip" "eip_1b" {
  instance = aws_instance.web.id
  domain   = "vpc"


  
  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-eip-1b"
  })
}




resource "aws_nat_gateway" "nat_gw_1b" {
  allocation_id = aws_eip.eip_1b.id
  subnet_id     = aws_subnet.frontend_subnent_1.id


 tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-nat-gw-1b"
  })

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_eip.eip_1b,aws_subnet.frontend_subnent_1_1b.id ]
} 


resource "aws_route_table" "private_rt_1b" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw_1b.id
  }


  tags = merge(var.tags, {
    Name = "${var.tags["project"]}-${var.tags["application"]}-${var.tags["environment"]}-private-rt-1b"
  })
}


resource "aws_route_table_association" "backend_subnent_1" {
  subnet_id      = aws_subnet.backend_subnent_2.id
  route_table_id = aws_route_table.private_rt_1b.id
}


resource "aws_route_table_association" "db_subnent_1" {
  subnet_id      = aws_subnet.db_subnent_3
  route_table_id = aws_route_table.private_rt_1b.id
}