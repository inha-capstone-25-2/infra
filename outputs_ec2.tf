output "server_public_ip" {
  value       = aws_instance.capstone_02_server_ec2.public_ip
  description = "Public IP of capstone_02_server_ec2"
}

output "server_public_dns" {
  value       = aws_instance.capstone_02_server_ec2.public_dns
  description = "Public DNS of capstone_02_server_ec2"
}

output "mongodb_public_ip" {
  value       = aws_instance.capstone_02_mongodb_ec2.public_ip
  description = "Public IP of capstone_02_mongodb_ec2"
}

output "mongodb_public_dns" {
  value       = aws_instance.capstone_02_mongodb_ec2.public_dns
  description = "Public DNS of capstone_02_mongodb_ec2"
}