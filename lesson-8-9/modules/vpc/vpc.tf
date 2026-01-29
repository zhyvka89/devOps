resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "lesson-5-vpc"
    Environment = var.environment
  }
}

# Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "lesson-5-igw"
  }
}

# Public Subnets (3)
resource "aws_subnet" "public" {
  count                   = length(var.public_subnets_cidr)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets_cidr[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "lesson-5-public-${count.index + 1}"
    "kubernetes.io/cluster/lesson-8-9-eks" = "shared"
    "kubernetes.io/role/elb"             = "1"
  }
}

# Private Subnets (3)
resource "aws_subnet" "private" {
  count             = length(var.private_subnets_cidr)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnets_cidr[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "lesson-5-private-${count.index + 1}"
    "kubernetes.io/cluster/lesson-8-9-eks" = "shared"
    "kubernetes.io/role/internal-elb"    = "1"
  }
}

# Elastic IP for NAT
resource "aws_eip" "nat" {
  domain = "vpc"
}

# NAT Gateway (у першій public subnet)
resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "lesson-5-nat"
  }

  depends_on = [aws_internet_gateway.this]
}
