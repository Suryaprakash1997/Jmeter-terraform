
resource "aws_security_group" "cs_stage_shared_jmeter_sg" {
  name        = "cs-stage-shared-jmeter-SG"
  description = "Allow communication between instances"
  vpc_id      = var.aws_vpc_id

tags = {
    CreatedBy   = "Surya"
    Environment = "staging"
    RequestedBy = "Harshil"
    Purpose     = "Jmeter loadtest"
  }

}

resource "aws_security_group_rule" "jmeter_all_ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true # allow traffic from the VPC to the security group
  security_group_id = aws_security_group.cs_stage_shared_jmeter_sg.id
}
resource "aws_security_group_rule" "jmeter_ssh_ingress" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cs_stage_shared_jmeter_sg.id
}

resource "aws_security_group_rule" "private_egress" {
  type      = "egress"
  from_port = 0
  to_port   = 0
  protocol  = -1
  self      = true

  security_group_id = aws_security_group.cs_stage_shared_jmeter_sg.id
}

resource "aws_security_group_rule" "public-egress" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = -1
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.cs_stage_shared_jmeter_sg.id
}
