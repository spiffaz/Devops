data "aws_availability_zones" "availabile" {
  state = "available"
}

# used by database instance
data "aws_ssm_parameter" "ubuntu_latest" {
  name = "/aws/service/canonical/ubuntu/server/18.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
}