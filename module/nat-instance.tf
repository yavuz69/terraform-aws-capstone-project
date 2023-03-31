resource "aws_instance" "nat" {
  depends_on = [aws_internet_gateway.gw]
  ami           = "ami-0356fe6f21ab7c13e"
  instance_type = "t2.micro"
#   vpc_id        = aws_vpc.capstone-v.id
  subnet_id     = aws_subnet.public-a.id
  vpc_security_group_ids = ["${aws_security_group.NAT-sec.id}"]
  key_name      = var.keyname
  source_dest_check    = false

  tags = {
    Name = "AWS Capstone NAT Instance"
  }
}









