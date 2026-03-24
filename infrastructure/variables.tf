variable "aws_region" {
  description = "La région AWS à utiliser"
  type        = string
  default     = "eu-west-3"
}

variable "project_name" {
  description = "Le nom du projet"
  type        = string
  default     = "sovereign-ai-hub"
}

variable "vpc_cidr" {
  description = "Le CIDR block du VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "Le CIDR block du subnet public"
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "Le type d'instance EC2"
  type        = string
  default     = "t3.micro"
}

variable "ssh_key_path" {
  description = "Chemin vers la clé SSH publique"
  type        = string
  default     = "~/.ssh/sovereign-key.pub"
}