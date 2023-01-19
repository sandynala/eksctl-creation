resource "aws_instance" "jenkins" {
  ami             = "ami-0283a57753b18025b"
  instance_type   = "t2.large"
  security_groups = [aws_security_group.jenkins-sg.name]
  key_name        = "mykey"
  provisioner "file" {
    source      = "jenkins.sh"
    destination = "/tmp/jenkins.sh"
  }
  # Configure the remote-exec to run the scripts in remote machine
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/jenkins.sh",
      "/tmp/jenkins.sh",
    ]
  }
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("C:\\Users\\lenovo\\Downloads\\mykey.pem")
  }
  tags = {
    "Name" = "Jenkins-server"
  }
}