data "aws_key_pair" "key" {
  key_name = var.key_name
}

resource "aws_instance" "minikube" {

  ami                         = var.minikube_ec2_ami
  instance_type               = var.minikube_instance_type
  key_name                    = data.aws_key_pair.key.key_name
  subnet_id                   = aws_subnet.public_subnet_az1.id
  security_groups             = [aws_security_group.webserver_security_group.id]
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    sudo su
    apt update
    apt -y install docker.io
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x ./kubectl && sudo mv ./kubectl /usr/local/bin/kubectl
    curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
    apt install conntrack

    cat <<EOT > /home/ubuntu/secrets.yml
    apiVersion: v1
    kind: Secret
    metadata:
      name: db-credentials
    type: Opaque
    data:
      MYSQL_HOST: $(echo -n ${aws_db_instance.mydb.endpoint} | base64 | tr -d '\n')
      MYSQL_USER: $(echo -n ${aws_db_instance.mydb.username} | base64 | tr -d '\n')
      MYSQL_PASSWORD: $(echo -n ${aws_db_instance.mydb.password} | base64 | tr -d '\n')
      MYSQL_DB: $(echo -n ${aws_db_instance.mydb.db_name} | base64 | tr -d '\n')
    EOT
  EOF

  tags = {
    "Name" = "MinikubeServer"
  }
}