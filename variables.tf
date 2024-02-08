variable "aws_profile" {
  default = "default"
}

variable "aws_region" {
  default = "ap-south-1"
}
variable "aws_ami" {
  description = "ID of AMI to use for the instance"
  type        = string
  default     = "ami-0a7cf821b91bcccbc"
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
  default     = "t3.small"
}
variable "aws_key_name" {
  description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource"
  type        = string
  default     = "Ubuntu"
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
