variable "ec2_key_name" {
  default = null
  type    = string

  description = <<-EOT
    The EC2 key name or null if an EC2 instance is not desired.
    EOT
}
