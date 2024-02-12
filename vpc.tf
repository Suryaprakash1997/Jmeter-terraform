module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "Jmeter_VPC"
  cidr = "128.0.0.0/16"

  azs             = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  private_subnets = ["128.0.1.0/24", "128.0.2.0/24", "128.0.3.0/24"]
  public_subnets  = ["128.0.101.0/24", "128.0.102.0/24", "128.0.103.0/24"]
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}
