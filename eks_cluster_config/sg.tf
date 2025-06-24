resource "aws_security_group" "allow_tls" {
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "allow_tls_ingress" { # Ingress Rule allows all traffic (any protocol, any port) from private IP ranges
  description       = "allow inbound traffic from eks"
  from_port         = 0      # from_port = 0, to_port = 0 is required with -1 protocol to cover all ports.
  protocol          = "-1"   # means all protocols (TCP, UDP, ICMP, etc.)
  to_port           = 0
  security_group_id = aws_security_group.allow_tls.id
  type              = "ingress"
  cidr_blocks = [
    "10.0.0.0/8",
    "172.16.0.0/12",
    "192.168.0.0/16",
  ]
}

resource "aws_security_group_rule" "allow_tls_egress" { # Eagress Rule allows outgoing traffic
  description       = "allow outbound traffic to anywhere"
  from_port         = 0
  protocol          = "-1" # all protocols, full access. This allows my worker nodes or EC2s to access the internet, S3, external APIs, etc.
  security_group_id = aws_security_group.allow_tls.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
} 