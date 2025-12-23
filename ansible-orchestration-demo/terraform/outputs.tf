# Outputs for Ansible inventory generation

output "load_balancer_ip" {
  description = "Public IP of the Nginx load balancer instance"
  value       = aws_instance.lb.public_ip
}

output "load_balancer_dns" {
  description = "Public DNS of the Nginx load balancer instance"
  value       = aws_instance.lb.public_dns
}

output "web_server_ips" {
  description = "Public IPs of web server instances"
  value       = aws_instance.web[*].public_ip
}

output "web_server_dns" {
  description = "Public DNS names of web server instances"
  value       = aws_instance.web[*].public_dns
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.main.arn
}

# Generate Ansible inventory file
resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/inventory.tpl", {
    lb_ip     = aws_instance.lb.public_ip
    web1_ip   = aws_instance.web[0].public_ip
    web2_ip   = length(aws_instance.web) > 1 ? aws_instance.web[1].public_ip : aws_instance.web[0].public_ip
    key_path  = var.ansible_ssh_key_path != "" ? var.ansible_ssh_key_path : "~/.ssh/${var.key_pair_name}.pem"
  })
  filename = "${path.module}/../inventory-aws.ini"
}

