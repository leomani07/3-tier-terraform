resource "aws_security_group" "public_sg" {
  name   = "public-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private_sg" {
  name   = "private-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "pub_server" {
  ami                         = "ami-0f58b397bc5c1f2e8" 
  instance_type               = "t2.micro"
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.public_sg.id]
  associate_public_ip_address = true
  key_name                    = "bharathi"

  user_data = file("${path.module}/user_data/pub-server.sh")

  tags = { Name = "pub-server" }
}

resource "aws_instance" "pvt_server" {
  ami                         = "ami-0f58b397bc5c1f2e8" 
  instance_type               = "t2.micro"
  subnet_id                   = var.private_subnet_id
  vpc_security_group_ids      = [aws_security_group.private_sg.id]
  associate_public_ip_address = false
  key_name                    = "bharathi"

  user_data = file("${path.module}/user_data/pvt-server.sh")

  tags = { Name = "pvt-server" }
}

