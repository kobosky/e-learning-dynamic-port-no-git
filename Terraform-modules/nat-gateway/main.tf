# allocate elastic ip. this eip will be used for the nat-gateway in the public subnet az1 
# project_name and environment was added to Nat-gateway variables
resource "aws_eip" "eip1" {
  vpc = true

  tags = {
    Name = "${var.project_name}-${var.environment}-eip1"
  }
}

# allocate elastic ip. this eip will be used for the nat-gateway in the public subnet az2
# project_name and environment was added to Nat-gateway variables
resource "aws_eip" "eip2" {
  vpc = true

  tags = {
    Name = "${var.project_name}-${var.environment}-eip2"
  }
}

# create nat gateway in public subnet az1
# project_name and environment was added to Nat-gateway variables
# output line 27 subnet_id then was added to Nat-gateway variables
resource "aws_nat_gateway" "nat_gateway_az1" {
  allocation_id = aws_eip.eip1.id
  subnet_id     = var.public_subnet_az1_id

  tags = {
    Name = "${var.project_name}-${var.environment}-ng-az1"
  }

  # to ensure proper ordering, it is recommended to add an explicit dependency
  # on the internet gateway for the vpc
  # output line 22 internet_gatway then was added to Nat-gateway variables
  depends_on = [var.internet_gateway]
}

# create nat gateway in public subnet az2
# project_name and environment was added to Nat-gateway variables
# output line 32 subnet_id then was added to Nat-gateway variables
resource "aws_nat_gateway" "nat_gateway_az2" {
  allocation_id = aws_eip.eip2.id
  subnet_id     = var.public_subnet_az2_id

  tags = {
    Name = "${var.project_name}-${var.environment}-ng-az2"
  }

  # to ensure proper ordering, it is recommended to add an explicit dependency
  # on the internet gateway for the vpc
  depends_on = [var.internet_gateway]
}

# create private route table az1 and add route through nat gateway az1
# project_name and environment was added to Nat-gateway variables
# output line 17 vpc_id then was added to Nat-gateway variables
# Nat-gate way nat_gateway_id from main line 24 
resource "aws_route_table" "private_route_table_az1" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_az1.id
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-private-rt-az1"
  }
}

# associate private app subnet az1 with private route table az1
# Nat-gate way route_table_id from main line 58 
# output line 37 private_app_subnet_az1_id then was added to Nat-gateway variables
resource "aws_route_table_association" "private_app_subnet_az1_rt_az1_association" {
  subnet_id      = var.private_app_subnet_az1_id
  route_table_id = aws_route_table.private_route_table_az1.id
}

# create private route table az2 and add route through nat gateway az2
# project_name and environment was added to Nat-gateway variables
# output line 17 vpc_id then was added to Nat-gateway variables
# Nat-gate way nat_gateway_id from main line 41 
resource "aws_route_table" "private_route_table_az2" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_az2.id
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-private-rt-az2"
  }
}

# associate private app subnet az2 with private route table az2
# output line 42 private_app_subnet_az1_id then was added to Nat-gateway variables
resource "aws_route_table_association" "private_app_subnet_az2_rt_az2_association" {
  subnet_id      = var.private_app_subnet_az2_id
  route_table_id = aws_route_table.private_route_table_az2.id
}
