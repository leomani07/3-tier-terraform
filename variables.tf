variable "region" {
  description = "AWS region"
  default     = "ap-south-1"
}

variable "key_name" {
  description = "EC2 key pair name"
  default     = "leo"
}

variable "ami_id" {
  description = "Ubuntu AMI for ap-south-1"
  default     = "ami-0f58b397bc5c1f2e8" 
}

variable "db_username" {
  description = "RDS master username"
  default     = "admin"
}

variable "db_password" {
  description = "RDS master password"
  default     = "Function!"
  sensitive   = true
}

