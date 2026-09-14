aws_region      = "ap-south-1"
allowed_regions = ["ap-south-1", "us-east-1"]

# Organization
create_organization = false

organizational_units = {
  Infrastructure = ["Network"]
}

accounts = {
  network = {
    name  = "Network"
    email = "santhirankanaga7339@gmail.com"
    ou    = "Infrastructure"
  }
}