provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

resource "aws_instance" "jmeter_worker_1" {
  count                  = var.jmeter_workers_count
  ami                    = var.aws_ami
  instance_type          = var.aws_worker_instance_type
  key_name               = var.aws_key_name
  subnet_id              = element(module.vpc.public_subnets, count.index)
  vpc_security_group_ids = [aws_security_group.jmeter_security_group.id]
  associate_public_ip_address = true
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install openjdk-11-jdk -y
              sudo wget https://dlcdn.apache.org//jmeter/binaries/apache-jmeter-5.6.3.tgz
              sudo tar -xzf apache-jmeter-5.6.3.tgz
              sudo rm apache-jmeter-5.6.3.tgz
              echo 'client.rmi.localport=50000' | sudo tee -a /apache-jmeter-5.6.3/bin/jmeter.properties
              echo 'server.rmi.localport=4000' | sudo tee -a /apache-jmeter-5.6.3/bin/jmeter.properties
              echo 'server.rmi.ssl.disable=true' | sudo tee -a /apache-jmeter-5.6.3/bin/jmeter.properties
              sudo ./apache-jmeter-5.6.3/bin/jmeter-server
              EOF
  
  tags = {
    Name = "jmeter_worker_1"
  }
}

output "worker-1_private_ip" {
  description = "The private IP address assigned to the worker(s) instance."
  value       = aws_instance.jmeter_worker_1[*].private_ip
}

resource "aws_instance" "jmeter_worker_2" {
  count                  = var.jmeter_workers_count
  ami                    = var.aws_ami
  instance_type          = var.aws_worker_instance_type
  key_name               = var.aws_key_name
  subnet_id              = element(module.vpc.public_subnets, count.index)
  vpc_security_group_ids = [aws_security_group.jmeter_security_group.id]
  associate_public_ip_address = true
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install openjdk-11-jdk -y
              sudo wget https://dlcdn.apache.org//jmeter/binaries/apache-jmeter-5.6.3.tgz
              sudo tar -xzf apache-jmeter-5.6.3.tgz
              sudo rm apache-jmeter-5.6.3.tgz
              echo 'client.rmi.localport=50000' | sudo tee -a /apache-jmeter-5.6.3/bin/jmeter.properties
              echo 'server.rmi.localport=4000' | sudo tee -a /apache-jmeter-5.6.3/bin/jmeter.properties
              echo 'server.rmi.ssl.disable=true' | sudo tee -a /apache-jmeter-5.6.3/bin/jmeter.properties
              sudo ./apache-jmeter-5.6.3/bin/jmeter-server
              EOF
  
  tags = {
    Name = "jmeter_worker_2"
  }
}

output "worker-2_private_ip" {
  description = "The private IP address assigned to the worker(s) instance."
  value       = aws_instance.jmeter_worker_2[*].private_ip
}

locals {
  all_worker_ips = join(",", concat(aws_instance.jmeter_worker_1[*].private_ip, aws_instance.jmeter_worker_2[*].private_ip))
}

resource "aws_instance" "jmeter_main" {
  count                  = var.jmeter_main_count
  ami                    = var.aws_ami
  instance_type          = var.aws_controller_instance_type
  key_name               = var.aws_key_name
  subnet_id              = element(module.vpc.public_subnets, count.index)
  vpc_security_group_ids = [aws_security_group.jmeter_security_group.id]
  associate_public_ip_address = true
  
  user_data = templatefile("${path.module}/user_data.tpl", {
    all_worker_ips = local.all_worker_ips
  })

  tags = {
    Name = "jmeter_controller"
  }

}
  
