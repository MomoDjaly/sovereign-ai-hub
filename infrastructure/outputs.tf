output "instance_public_ip" {
  description = "L'IP publique de l'EC2"
  value       = aws_instance.main.public_ip
}

output "instance_id" {
  description = "L'ID de l'instance EC2"
  value       = aws_instance.main.id
}