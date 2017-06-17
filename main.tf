data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "chicken" {
  name = "allows SSH"
  description = "Allows SSH in from anywhere"
  #vpc_id = "${aws_vpc.default.id}"

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    self        = true
  }

  # tags {
  #   Name = "airpair-example-default-vpc"
  # }
}


resource "aws_instance" "torrent_box" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.small"
  user_data = "${file("cool.yml")}"
  #user_data = "${file(\"app.yml\")}"
  vpc_security_group_ids = ["${aws_security_group.chicken.id}"]
  key_name = "claralinux"

  tags {
    Name = "HelloWorld"
  }
}
