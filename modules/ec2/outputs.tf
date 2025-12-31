output "id" {
  description = "The ID of the instance"
  value       = aws_instance.this.id
}

output "private_ip" {
  description = "The private IP address of the instance"
  value       = aws_instance.this.private_ip
}

output "public_ip" {
  description = "The public IP address of the instance"
  value       = aws_instance.this.public_ip
}

output "public_dns" {
  description = "The public DNS of the instance"
  value       = aws_instance.this.public_dns
}

output "availability_zone" {
  description = "The availability zone of the instance"
  value       = aws_instance.this.availability_zone
}
