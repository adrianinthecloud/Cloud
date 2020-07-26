provider "aws" {
  profile = "default"
  region  = "ap-southeast-2"
}

variable "subnet_id" {}

data "aws_subnet" "selected" {
  id = "${var.subnet_id}"
}

resource "aws_instance" "example" {
  ami           = "ami-0a58e22c727337c51"
  instance_type = "t2.micro"
  subnet_id     = data.aws_subnet.selected.id
  private_ip    = "10.0.1.8"
  tags          = {
     Name = "Terraform Modified Instance"
  }
}


resource "aws_eip" "instance-ip" {
  vpc                       = true
  instance                  = aws_instance.example.id
  associate_with_private_ip = "10.0.1.8"
  depends_on                = [aws_instance.example]
}
