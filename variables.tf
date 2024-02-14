variable "aws_profile" {
  default = "stage-admin"
}

variable "aws_region" {
  default = "us-east-1"
}
variable "aws_ami" {
  description = "ID of AMI to use for the instance"
  type        = string
  default     = "ami-06aa3f7caf3a30282"
  validation {
    condition     = length(var.aws_ami) > 4 && substr(var.aws_ami, 0, 4) == "ami-"
    error_message = "The image_id value must be a valid AMI id, starting with \"ami-\"."
  }
}
variable "aws_controller_instance_type" {
  description = "The type of controller instance to start"
  type        = string
  default     = "t3.medium"
}
variable "aws_worker_instance_type" {
  description = "The type of worker instance(s) to start"
  type        = string
  default     = "t3.medium"
}
variable "aws_key_name" {
  description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource"
  type        = string
  default     = "cs-stage-shared-jmeter-vm-key"
}

variable "jmeter_home" {
  description = "The location of the home directory"
  type        = string
  default     = "/home/ubuntu"
}

variable "jmeter_workers_count" {
  description = "The number of worker nodes to run"
  default     = 1
  type        = number

  validation {
    condition     = (var.jmeter_workers_count) >= 1
    error_message = "The number of worker nodes must be greater than 0."
  }
}
variable "jmeter_main_count" {
  description = "The leader/controller node must be 1."
  default     = 1
  type        = number

  validation {
    condition     = var.jmeter_main_count == 1
    error_message = "The leader/controller node must be 1."
  }

} 

variable "aws_vpc_id" {
  description = "vpc ID for the Jmeter"
  type = string
  default = "vpc-002157042a4908b2c"
}

variable "aws_subnet_id" {
  description = "subnet ID for the Jmeter"
  type = string
  default = "subnet-028301881608dd0b1"
}