# ec2-instance

Single EC2 instance for tunnel/jump workloads. Supports optional IAM instance profile, encrypted root volume, and IMDSv2.

## Example

```hcl
module "db_tunnel" {
  source = "../../modules/ec2-instance"

  name                 = "acpt-db-tunnel"
  instance_type        = "t4g.micro"
  subnet_id            = module.vpc.private_subnet_ids[0]
  security_group_ids   = [module.tunnel_sg.security_group_id]
  iam_instance_profile = module.tunnel_role.instance_profile_name

  tags = var.tags
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | AMI ID for the instance. When null, resolves the latest Amazon Linux 2023 AMI for ami\_variant and architecture. | `string` | `null` | no |
| <a name="input_ami_variant"></a> [ami\_variant](#input\_ami\_variant) | Amazon Linux 2023 AMI variant when ami\_id is null: standard (full OS) or minimal. | `string` | `"standard"` | no |
| <a name="input_architecture"></a> [architecture](#input\_architecture) | CPU architecture used when resolving the default Amazon Linux 2023 AMI (arm64 or x86\_64) | `string` | `"arm64"` | no |
| <a name="input_associate_public_ip_address"></a> [associate\_public\_ip\_address](#input\_associate\_public\_ip\_address) | Whether to associate a public IP address with the instance | `bool` | `false` | no |
| <a name="input_iam_instance_profile"></a> [iam\_instance\_profile](#input\_iam\_instance\_profile) | IAM instance profile name for the instance | `string` | `null` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | EC2 instance type | `string` | `"t4g.micro"` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | Optional EC2 key pair name for SSH access | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name tag for the EC2 instance | `string` | n/a | yes |
| <a name="input_root_volume_size_gb"></a> [root\_volume\_size\_gb](#input\_root\_volume\_size\_gb) | Root EBS volume size in GiB. Amazon Linux 2023 AMIs require at least 30 GiB (AMI root snapshot size). | `number` | `30` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of security group IDs to attach to the instance | `list(string)` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | Subnet ID where the instance is launched | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the EC2 instance and root volume | `map(string)` | `{}` | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | Optional user data script (plain text) | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ami_id"></a> [ami\_id](#output\_ami\_id) | AMI ID used by the instance |
| <a name="output_availability_zone"></a> [availability\_zone](#output\_availability\_zone) | Availability zone of the instance |
| <a name="output_instance_arn"></a> [instance\_arn](#output\_instance\_arn) | EC2 instance ARN |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | EC2 instance ID |
| <a name="output_private_ip"></a> [private\_ip](#output\_private\_ip) | Private IP address of the instance |
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | Public IP address of the instance (if associated) |
<!-- END_TF_DOCS -->
