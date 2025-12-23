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

1. **AWS CLI configured** with credentials
   ```bash
   aws configure
   ```

2. **Terraform installed** (>= 1.0)
   ```bash
   brew install terraform  # macOS
   # or download from https://www.terraform.io/downloads
   ```

3. **AWS EC2 Key Pair** created in your AWS account
   - Go to EC2 → Key Pairs → Create Key Pair
   - Download the `.pem` file
   - Save it to `~/.ssh/` with appropriate permissions

## Quick Start

### 1. Configure Variables

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` and update:
- `key_pair_name`: Your AWS EC2 Key Pair name
- `aws_region`: Your preferred AWS region
- `ssh_cidr`: Your IP address for SSH access (optional, defaults to 0.0.0.0/0)

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Review Plan

```bash
terraform plan
```

### 4. Apply Infrastructure

```bash
terraform apply
```

Type `yes` when prompted. This will:
- Create all AWS resources
- Generate `inventory-aws.ini` automatically with server IPs

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

1. Verify key permissions:
   ```bash
   chmod 400 ~/.ssh/your-key.pem
   ```

2. Check security group allows your IP:
   - Update `ssh_cidr` in `terraform.tfvars`

### Terraform Errors

- **"Key pair not found"**: Create the key pair in AWS Console first
- **"Insufficient permissions"**: Ensure your AWS credentials have EC2, VPC, and IAM permissions
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

