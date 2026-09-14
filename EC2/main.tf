resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.instance_name}-vpc"
  }
}

resource "aws_internet_gateway" "vpc" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.instance_name}-igw"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.instance_name}-public-subnet"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc.id
  }

  tags = {
    Name = "${var.instance_name}-public-route-table"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "allow_All" {
  name        = "allow_ALL"
  description = "Allow ALL inbound traffic and outbound traffic"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.instance_name}-sg-allow-all"
  }
}

resource "aws_key_pair" "name" {
  key_name   = "${var.instance_name}-key"
  public_key = file("${var.key_name}")
}

resource "aws_instance" "my" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  security_groups             = [aws_security_group.allow_All.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.name.key_name

  ebs_block_device {
    device_name = "/dev/sdh"
    volume_size = 10
    volume_type = "gp3"
  }

  user_data = <<-EOF
      #!/bin/bash
      apt-get update -y

      # Docker + Docker Compose
      apt-get install -y docker.io docker-compose-v2

      systemctl enable --now docker

      # Networking tools
      apt-get install -y \
        curl \
        wget \
        net-tools \
        iproute2 \
        iputils-ping \
        dnsutils \
        traceroute \
        mtr-tiny \
        nmap \
        tcpdump \
        netcat-openbsd \
        telnet \
        whois \
        openssh-client

      # ZIP / TAR tools
      apt-get install -y \
        zip \
        unzip \
        tar

      echo "========== Docker =========="
      docker --version
      docker compose version

      echo "========== Networking =========="
      ip addr
      ss --version
      curl --version
      wget --version

      echo "========== Archive tools =========="
      zip -v
      unzip -v
      tar --version

      echo "========== Installation Complete =========="
    EOF      

  tags = {
    Name = "${var.instance_name}"
  }
}

