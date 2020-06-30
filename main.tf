provider "aws" {
    region = "eu-west-1"
}

resource "aws_instance" "example" {
    ami = "ami-f90a4880"
    instance_type = "t2.micro"
    vpc_security_group_ids = ["${aws_security_group.instance.id}"]
    key_name = "${aws_key_pair.terraform-demo.key_name}"

    tags = {
        Name = "terraform-example"
    }

    user_data = file("init.sh")
}

resource "aws_security_group" "instance" {
	name = "terraform-example-instance"

	ingress {
    	from_port = var.server_port
    	to_port = var.server_port
    	protocol = "tcp"
    	cidr_blocks = ["0.0.0.0/0"]
  	}
}

resource "aws_key_pair" "terraform-demo" {
    key_name   = "terraform-demo"
    public_key = file("terraform-demo.pub")
}

variable "server_port" {
	description = "Server port for HTTP requests"
	default = 8080
}

output "public_ip" {
	value = aws_instance.example.public_ip
}
