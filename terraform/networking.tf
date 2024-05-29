resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "Name" = "todoVPC"
  }
}

resource "aws_subnet" "public_subnet_az1" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "todo-public-subnet"
  }
}

resource "aws_subnet" "private_subnet_az2" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "todo-private-subnet"
  }
}

resource "aws_internet_gateway" "mygateway" {
  vpc_id = aws_vpc.myvpc.id
}

resource "aws_route_table" "publicRT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mygateway.id
  }

  tags = {
    "Name" = "todo-public-RT"
  }
}

resource "aws_route_table" "privateRT" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "todo-private-RT"
  }
}

resource "aws_route_table_association" "publicRTassociation" {
  subnet_id      = aws_subnet.public_subnet_az1.id
  route_table_id = aws_route_table.publicRT.id
}

resource "aws_route_table_association" "privateRTassociation" {
  subnet_id      = aws_subnet.private_subnet_az2.id
  route_table_id = aws_route_table.privateRT.id
}

resource "aws_security_group" "webserver_security_group" {
  name        = "webserver_security_group"
  description = "Allow ssh and http conections"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "node"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "mysql/aurora access"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG-webservice"
  }
}

resource "aws_security_group" "database_security_group" {
  name        = "database security group"
  description = "enable mysql/aurora access on port 3306"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description     = "mysql/aurora access"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.webserver_security_group.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG-database-todo"
  }
}

resource "aws_db_subnet_group" "database_subnet_group" {
  name        = "database-subnets"
  subnet_ids  = [aws_subnet.public_subnet_az1.id, aws_subnet.private_subnet_az2.id]
  description = "subnets for database"

  tags = {
    Name = "database-subnets"
  }
}