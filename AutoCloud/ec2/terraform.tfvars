aws_region        = "us-east-1"
availability_zone = "us-east-1a"

instance_name = "secure-vm"

ami_id = "ami-013acec81a2c8ff79"

instance_type = "t3.micro"
monitoring    = true

root_volume_size = 30
root_volume_type = "gp3"

create_vpc            = true
vpc_cidr              = "10.0.0.0/16"
create_subnet         = true
subnet_cidr           = "10.0.1.0/24"
create_security_group = true

subnet_id          = ""
security_group_ids = []
allowed_cidr       = []

associate_public_ip_address = false
use_elastic_ip              = true

user_data_file = ""

public_key_path = "./id_rsa.pub"

default_tags = {
  ManagedBy = "AutoCloud"
  Name      = "secure-vm"
}
