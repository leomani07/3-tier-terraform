output "pub_server_public_ip" {
  value = aws_instance.pub_server.public_ip
}

output "pvt_server_private_ip" {
  value = aws_instance.pvt_server.private_ip
}

output "private_sg_id" {
  value = aws_security_group.private_sg.id
}

