resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "all_worker_management"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group_rule" "all_worker_mgmt_ingress" {
  description       = "allow inbound traffic from eks"
  from_port         = 0
  protocol          = "-1"
  to_port           = 0
  security_group_id = aws_security_group.all_worker_mgmt.id
  type              = "ingress"
  cidr_blocks = [
    "10.0.0.0/8",
    "172.16.0.0/12",
    "192.168.0.0/16",
  ]
}

resource "aws_security_group_rule" "all_worker_mgmt_egress" {
  description       = "allow outbound traffic to anywhere"
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.all_worker_mgmt.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}

# Attach the same security group to both clusters
resource "aws_eks_cluster" "cluster1" {
  // Cluster 1 configuration
  vpc_config {
    // other configurations...
    security_group_ids = [aws_security_group.all_worker_mgmt.id]
  }
}

resource "aws_eks_cluster" "cluster2" {
  // Cluster 2 configuration
  vpc_config {
    // other configurations...
    security_group_ids = [aws_security_group.all_worker_mgmt.id]
  }
}
