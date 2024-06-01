output "jenkins_public_ip" {
  value = aws_instance.jenkins.public_ip
}

output "minikube_public_ip" {
  value = aws_instance.minikube.public_ip
}

output "db_endpoint" {
  value = aws_db_instance.mydb.endpoint
}

output "db_username" {
  value = aws_db_instance.mydb.username
}