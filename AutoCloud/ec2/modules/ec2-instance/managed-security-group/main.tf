resource "aws_iam_role" "this" {
  name = "${var.instance_name}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(var.tags, {
    Name = "${var.instance_name}-ec2-role"
  })
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.instance_name}-ec2-profile"
  role = aws_iam_role.this.name

  tags = merge(var.tags, {
    Name = "${var.instance_name}-ec2-profile"
  })
}

resource "aws_instance" "this" {
  ami               = var.ami_id
  instance_type     = var.instance_type
  subnet_id         = var.subnet_id
  key_name          = var.key_name
  monitoring        = var.monitoring
  get_password_data = var.ami_is_windows
  user_data         = var.user_data
  ebs_optimized     = true

  iam_instance_profile = aws_iam_instance_profile.this.name

  vpc_security_group_ids = [aws_security_group.this.id]

  associate_public_ip_address = var.associate_public_ip_address
  user_data_replace_on_change = true

  volume_tags = merge(var.tags, {
    Name = "${var.instance_name}-root"
  })

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  root_block_device {
    encrypted   = true
    volume_type = var.root_volume_type
    volume_size = var.root_volume_size
  }

  tags = merge(var.tags, {
    Name = var.instance_name
  })
}

resource "aws_eip" "this" {
  count = var.use_elastic_ip ? 1 : 0

  instance = aws_instance.this.id
  domain   = "vpc"

  tags = merge(var.tags, {
    Name = "${var.instance_name}-eip"
  })
}
