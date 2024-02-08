resource "aws_instance" "jmeter_worker" {
  count                  = var.jmeter_workers_count
  ami                    = var.aws_ami
  instance_type          = var.aws_worker_instance_type
  key_name               = var.aws_key_name
  subnet_id              = element(module.vpc.public_subnets, count.index)
  vpc_security_group_ids = [aws_security_group.jmeter_security_group.id]
  associate_public_ip_address = true
  user_data = templatefile("${path.module}/install-jmeter.sh", {
    JMETER_HOME                         = var.jmeter_home,
    JMETER_VERSION                      = var.jmeter_version,
    JMETER_DOWNLOAD_URL                 = "https://dlcdn.apache.org//jmeter/binaries/apache-jmeter-5.6.3.tgz",
    JMETER_MODE                         = var.jmeter_mode
  })
  tags = {
    Name = "jmeter_worker"
  }


}
  
