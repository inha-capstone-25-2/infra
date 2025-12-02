output "server_public_ip" {
  value       = aws_instance.server_ec2.public_ip
  description = "Public IP of server EC2"
}

output "server_public_dns" {
  value       = aws_instance.server_ec2.public_dns
  description = "Public DNS of server EC2"
}

output "mongodb_public_ip" {
  value       = aws_instance.mongodb_ec2.public_ip
  description = "Public IP of mongodb EC2"
}

output "mongodb_public_dns" {
  value       = aws_instance.mongodb_ec2.public_dns
  description = "Public DNS of mongodb EC2"
}

output "es_public_ip" {
  value       = aws_instance.es_ec2.public_ip
  description = "Public IP of Elasticsearch EC2"
}

output "es_public_dns" {
  value       = aws_instance.es_ec2.public_dns
  description = "Public DNS of Elasticsearch EC2"
}