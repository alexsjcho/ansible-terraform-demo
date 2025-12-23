# AWS Infrastructure Setup

This directory contains Terraform configuration to provision AWS infrastructure for the Ansible orchestration demo.

## What Gets Created

- **VPC** with public subnets across 2 availability zones
- **Internet Gateway** for public internet access
- **Security Groups**:
  - ALB security group (allows HTTP from internet)
  - Web server security group (allows HTTP from ALB, SSH from specified CIDR)
- **Application Load Balancer** (AWS ALB) - optional, for reference
- **Target Group** for ALB health checks
- **EC2 Instances**:
  - 1 instance for Nginx load balancer
  - 2 instances for web servers (configurable)

## Prerequisites

1. **Terraform installed** (>= 1.0)
   ```bash
   brew install terraform  # macOS
   # or download from https://www.terraform.io/downloads
   ```

2. **AWS Account** with IAM user credentials:
   - `AmazonEC2FullAccess` policy
   - `ElasticLoadBalancingFullAccess` policy

## Quick Start

### 1. Configure AWS Credentials

```bash
cd terraform
cp .env.example .env
```

Edit `.env` with your AWS credentials:
```bash
export AWS_ACCESS_KEY_ID="your-access-key-id"
export AWS_SECRET_ACCESS_KEY="your-secret-access-key"
```

### 2. Initialize and Apply

```bash
source .env
terraform init
terraform apply
```

Type `yes` when prompted. This will:
- Create all AWS resources (VPC, security groups, EC2 instances, ALB)
- Auto-generate SSH key pair and save to `~/.ssh/ansible-demo-key.pem`
- Generate `inventory-aws.ini` with all server IPs configured

### 5. Use Generated Inventory

After Terraform completes, use the generated inventory:

```bash
cd ..
ansible-playbook -i inventory-aws.ini site.yml
```

## Outputs

After `terraform apply`, you'll see:
- Load balancer public IP
- Web server public IPs
- ALB DNS name (if using AWS ALB)
- Auto-generated `inventory-aws.ini` file

## Destroy Infrastructure

To tear down all resources (saves costs):

```bash
cd terraform
source .env
terraform destroy
```

Type `yes` when prompted.

## Cost Estimate

Approximate monthly cost (us-east-1, t3.micro):
- 3x t3.micro instances: ~$30/month
- ALB: ~$16/month
- Data transfer: varies
- **Total: ~$50-60/month**

**Note**: Always destroy resources when not in use to avoid charges.

## Troubleshooting

### SSH Connection Issues

1. The SSH key is auto-generated at `~/.ssh/ansible-demo-key.pem` with correct permissions (0400)

2. Check security group allows your IP:
   - Update `ssh_cidr` variable if needed

### Terraform Errors

- **"SSO profile not found"**: Run `source .env` to set AWS credentials
- **"Insufficient permissions"**: Ensure your IAM user has `AmazonEC2FullAccess` and `ElasticLoadBalancingFullAccess` policies
- **"AMI not found"**: The Ubuntu AMI might not be available in your region - update the AMI filter in `main.tf`

### Ansible Connection Issues

1. Wait 2-3 minutes after `terraform apply` for instances to fully boot
2. Test connectivity:
   ```bash
   ansible all -i inventory-aws.ini -m ping
   ```

## Architecture Notes

- **Nginx Load Balancer**: The demo uses a separate EC2 instance running Nginx as the load balancer (as per original requirements)
- **AWS ALB**: Also created for reference, but the demo focuses on Nginx LB orchestration
- **Public Subnets**: All instances are in public subnets for simplicity (production would use private subnets)

## Security Recommendations

1. **Restrict SSH access**: Update `ssh_cidr` to your IP address
2. **Use private subnets**: Move web servers to private subnets in production
3. **Add WAF**: Add AWS WAF to ALB for production
4. **Enable SSL/TLS**: Add SSL certificates and HTTPS listeners

