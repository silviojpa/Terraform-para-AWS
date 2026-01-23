# 1. Definir o Provider
provider "aws" {
  region     = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# 2. Criar a VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = { Name = "ubuntu-vpc" }
}

# 3. Criar a Subnet (Pública)
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags                    = { Name = "ubuntu-subnet" }
}

# 4. Internet Gateway (Para dar acesso à internet)
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
}

# 5. Tabela de Roteamento
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.rt.id
}

# 6. Security Group (Porta 22 para SSH e 80 para HTTP)
resource "aws_security_group" "sg_ubuntu" {
  name   = "allow_ssh_http"
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Em produção, limite ao seu IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 7. Instância EC2 (Ubuntu 22.04 LTS)
resource "aws_instance" "ubuntu_server" {
  ami           = "ami-0c7217cdde317cfec" # AMI padrão Ubuntu em us-east-1
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.sg_ubuntu.id]

  tags = {
    Name = "MeuUbuntuServer"
  }
}
