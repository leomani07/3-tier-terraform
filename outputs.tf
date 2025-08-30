output "pub_server_public_ip" {
  value = module.ec2.pub_server_public_ip
}

output "pvt_server_private_ip" {
  value = module.ec2.pvt_server_private_ip
}

output "rds_endpoint" {
  value = module.rds.rds_endpoint
}
