variable "ami_ubuntu_arm" {
  default     = "ami-0903fdada63611430"
  description = "Ubuntu 18.04"
}

variable "ami_nginx" {
  default     = "ami-0b8000a2ff66702ae"
  description = "Two servers Nginx"
}

variable "ec2_type_t4g_nano" {
  default     = "t4g.nano"
  description = "Type instance"
}

variable "ec2_type_t2_micro" {
  default     = "t2.micro"
  description = "Type instance"
}

variable "all_traffic" {
  default     = "0.0.0.0/0"
  description = "All ip traffic"
}