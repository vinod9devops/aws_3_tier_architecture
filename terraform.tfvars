aws_region = "ap-southeast-1"
#profile           = "my-poc-profile"
environment       = "dev"
vpc_cidr          = "10.0.0.0/16"
public_subnets    = ["10.0.101.0/24", "10.0.102.0/24"]
private_subnets   = ["10.0.1.0/24", "10.0.2.0/24"]
database_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]
web_instance_type = "t2.micro"
app_instance_type = "t2.micro"
db_instance_class = "db.t2.micro"
db_username       = "admin"
db_password       = "admin" # Choose your own password
multi_az          = false