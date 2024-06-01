variable "region" {
  type    = string
  default = "us-east-1"
}

variable "aws_config_path" {
  type    = string
  default = "$HOME/.aws/config"
}

variable "aws_credentials_path" {
  type    = string
  default = "$HOME/.aws/credentials"
}

variable "key_name" {
  type    = string
  default = "testkey"
}

variable "minikube_instance_type" {
  type    = string
  default = "t2.xlarge"
}

variable "jenkins_instance_type" {
  type    = string
  default = "t2.large"
}

variable "ec2_ami" {
  type    = string
  default = "ami-04b70fa74e45c3917"
}

variable "db_username" {
  type    = string
  default = "username"
}

variable "db_password" {
  type    = string
  default = "testPassword1?"
}

variable "db_name" {
  type    = string
  default = "todos"
}

variable "db_engine" {
  type    = string
  default = "mysql"
}

variable "db_engine_version" {
  type    = string
  default = "8.0.35"
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "db_identifier" {
  type    = string
  default = "todo-list-rds"
}

variable "db_storage" {
  type    = number
  default = 20
}