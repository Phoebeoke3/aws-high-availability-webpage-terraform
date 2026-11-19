# Highly Available AWS Webpage Using Terraform

## Project Overview

This project demonstrates the deployment of a highly available and scalable webpage on Amazon Web Services (AWS) using Terraform as the Infrastructure as Code (IaC) tool.

The infrastructure is designed to provide global content delivery, automatic scaling and fault tolerance across two Availability Zones.

## AWS Architecture

The solution uses the following services:

- **Amazon VPC:** Isolated network with two public and two private subnets.
- **Amazon EC2:** Hosts a simple HTML webpage using a Python HTTP server.
- **Application Load Balancer:** Distributes requests across healthy EC2 instances.
- **EC2 Auto Scaling:** Automatically adjusts server capacity based on CPU utilisation.
- **Amazon CloudFront:** Delivers the webpage through a global content delivery network.
- **Amazon CloudWatch:** Monitors instance health and scaling metrics.
- **Terraform:** Provisions and manages the AWS infrastructure.

**Request flow:** Visitors → CloudFront → Application Load Balancer → EC2 Web Servers.

## Project Files

| File | Purpose |
|---|---|
| `provider.tf` | AWS provider configuration |
| `network.tf` | VPC, subnets and routing |
| `security.tf` | ALB and EC2 security groups |
| `loadbalancer.tf` | Load balancer, target group and listener |
| `compute.tf` | EC2 launch template and Auto Scaling Group |
| `monitoring.tf` | Scaling policy and CloudWatch alarm |
| `cloudfront.tf` | CloudFront distribution |
| `outputs.tf` | Website URL and infrastructure outputs |
| `webserver.sh` | Webpage creation and startup script |

## Deployment Procedure

**Prerequisites:** Terraform, AWS CLI and an AWS account with appropriate IAM permissions.

1. Clone the repository.
2. Authenticate using AWS CLI.
3. Run the following commands:

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

4. Access the website using the CloudFront URL displayed in Terraform outputs.

**Note:** Deployment provisions billable AWS resources. Review expected charges before applying the configuration.

## Testing and Results

- Successfully deployed the AWS infrastructure using Terraform.
- Verified the webpage was accessible through CloudFront.
- Confirmed two healthy EC2 targets across separate Availability Zones.
- Tested fault recovery by terminating one EC2 instance; Auto Scaling successfully launched a replacement.
- Demonstrated CPU-based scale-out from two to three EC2 instances using a temporary 0.1% CPU target.
- Restored the normal CPU target to 50% after testing.
- Verified CloudWatch monitoring and successful Terraform configuration reconciliation.

## Challenges and Lessons Learned

Initial deployment produced a 502 Bad Gateway error because the EC2 startup scripts failed. Troubleshooting involved examining Cloud-init logs, correcting Bash script formatting and updating the Terraform launch template.

This highlighted the importance of startup validation, cloud monitoring and repeatable infrastructure configuration.

## Resource Cleanup

To remove Terraform-managed AWS infrastructure after testing:

```bash
terraform destroy
```

Review the destroy plan before confirming and verify the resources have been removed.

## References

- [Terraform Documentation](https://developer.hashicorp.com/terraform)
- [AWS Documentation](https://docs.aws.amazon.com/)
- [Amazon EC2 Auto Scaling](https://docs.aws.amazon.com/autoscaling/ec2/userguide/)
- [Amazon CloudFront](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/)