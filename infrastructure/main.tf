terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# ================================
# VPC - Réseau privé principal
# ================================

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name    = "${var.project_name}-vpc"
    Project = var.project_name
  }
}

# ====================================================
# Subnet public - Machines accessibles depuis Internet
# ====================================================

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name    = "${var.project_name}-subnet-public"
    Project = var.project_name
  }
}

# =========================================
# Internet Gateway - La porte vers Internet
# =========================================

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name    = "${var.project_name}-igw"
    Project = var.project_name
  }
}

# ================================
# Route Table - Le GPS du réseau
# ================================

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name    = "${var.project_name}-rt-public"
    Project = var.project_name
  }
}

# =================================================
# Association Route Table + Subnet - Le branchement
# =================================================

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# ===========================================
# Security Group - Le pare-feu de ton serveur
# ===========================================

resource "aws_security_group" "ssh" {
  name        = "${var.project_name}-sg-ssh"
  description = "Autorise SSH depuis mon IP"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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
    Name    = "${var.project_name}-sg-ssh"
    Project = var.project_name
  }
}


# Bonne question — avant de lancer quoi que ce soit, tu dois comprendre ce que tu as écrit. Voilà l'explication     # complète de chaque ressource :

# ---

#🧠 Explication des 6 ressources

# 1. `aws_vpc` — Ton réseau privé
# C'est ton datacenter virtuel dans AWS. Tout ce qu'on va créer (serveurs, bases de données...) vivra dedans.       # Le `cidr_block = "10.0.0.0/16"` définit la plage d'adresses IP disponibles dans ce réseau — 65 536 adresses       # possibles.

# ---

# 2. `aws_subnet` — Un étage dans ton réseau
# Le VPC c'est l'immeuble, le subnet c'est un étage. On crée un subnet **public** avec `10.0.1.0/24` (256 adresses). # Le `map_public_ip_on_launch = true` signifie que chaque serveur qui démarre dedans reçoit automatiquement une IP  # accessible depuis Internet.

# ---

# 3. `aws_internet_gateway` — La porte vers Internet
# Sans lui, ton VPC est une boîte fermée. Personne ne peut entrer, rien ne peut sortir. L'IGW c'est la connexion    # entre ton réseau privé AWS et Internet.

# ---

# 4. `aws_route_table` — Le GPS du réseau
# Il dit à AWS comment router le trafic. La règle `0.0.0.0/0 → IGW` signifie : *"tout ce qui veut aller sur         # Internet, passe par l'Internet Gateway"*.

# ---

# 5. `aws_route_table_association` — Le branchement
#   La route table toute seule ne fait rien. Cette ressource la **branche sur le subnet**. Sans ça, le subnet ne    #   sait pas qu'il doit utiliser cette route table.

# ---

# 6. `aws_security_group` — Le pare-feu de ton serveur
# Il contrôle ce qui entre et ce qui sort :
# - `ingress` port 22 = SSH autorisé en entrée
# - `egress` tout ouvert = ton serveur peut contacter n'importe quoi sur Internet

# ---

# Le schéma complet de ce qu'on a codé


# Internet
#   ↕  (Internet Gateway)
#   ↕
# VPC 10.0.0.0/16
#   ↕  (Route Table → IGW)
#   ↕
# Subnet public 10.0.1.0/24
#   ↕  (Security Group → port 22 ouvert)
#   ↕
# [EC2 demain]



