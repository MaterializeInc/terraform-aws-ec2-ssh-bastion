resource "aws_security_group" "ssh_bastion" {
  name        = "ssh_bastion"
  description = "Allow SSH access to bastion host"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = distinct(concat(var.mz_egress_ips, [format("%s/%s", data.http.user_public_ip.response_body, "32")]))
  }

  vpc_id = data.aws_vpc.mz_vpc.id
}

resource "aws_key_pair" "ssh_bastion" {
  key_name_prefix = "mz-bastion-ssh-"
  public_key      = var.ssh_public_key
}

resource "aws_instance" "ssh_bastion" {
  ami           = data.aws_ami.ubuntu.id
  key_name      = aws_key_pair.ssh_bastion.key_name
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  root_block_device {
    volume_size           = var.volume_size
    delete_on_termination = true
  }

  vpc_security_group_ids = [aws_security_group.ssh_bastion.id]

  associate_public_ip_address = var.associate_public_ip_address

  # Install unattended-upgrade package to automatically install security updates
  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y unattended-upgrades
              EOF
}
