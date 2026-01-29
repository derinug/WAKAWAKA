# 4. S3 Gateway Endpoint
resource "aws_vpc_endpoint" "lks_s3_endpoint" {
  vpc_id            = aws_vpc.hybrid_vpc.id
  service_name      = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [
    aws_route_table.hybrid_private_rt.id
  ]

  tags = {
    Name = "lks-s3-endpoints"
  }
}

# 5. EventBridge Interface Endpoint
resource "aws_vpc_endpoint" "lks_eventbridge_endpoint" {
  vpc_id            = aws_vpc.hybrid_vpc.id
  service_name      = "com.amazonaws.us-east-1.events"
  vpc_endpoint_type = "Interface"
  subnet_ids = [
    aws_subnet.priv_sub_1.id,
    aws_subnet.priv_sub_2.id
  ]
  security_group_ids  = [aws_security_group.lks_sg_vpc_endpoint.id]
  private_dns_enabled = true

  tags = {
    Name = "lks-eventbridge-endpoints"
  }
}

# 6. Step Functions Interface Endpoint
resource "aws_vpc_endpoint" "lks_steps_endpoint" {
  vpc_id            = aws_vpc.hybrid_vpc.id
  service_name      = "com.amazonaws.us-east-1.states"
  vpc_endpoint_type = "Interface"
  subnet_ids = [
    aws_subnet.priv_sub_1.id,
    aws_subnet.priv_sub_2.id
  ]
  security_group_ids  = [aws_security_group.lks_sg_vpc_endpoint.id]
  private_dns_enabled = true

  tags = {
    Name = "lks-steps-endpoints"
  }
}

# 7. SNS Interface Endpoint
resource "aws_vpc_endpoint" "lks_sns_endpoint" {
  vpc_id            = aws_vpc.hybrid_vpc.id
  service_name      = "com.amazonaws.us-east-1.sns"
  vpc_endpoint_type = "Interface"
  subnet_ids = [
    aws_subnet.priv_sub_1.id,
    aws_subnet.priv_sub_2.id
  ]
  security_group_ids  = [aws_security_group.lks_sg_vpc_endpoint.id]
  private_dns_enabled = true

  tags = {
    Name = "lks-sns-endpoints"
  }
}

resource "random_string" "suffix" {
  length  = 1
  special = false
  upper   = false
}