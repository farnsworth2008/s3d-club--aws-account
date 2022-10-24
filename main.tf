data "aws_vpc" "this" {
  default = true
}

locals {
  group = module.site_group
}

module "go_site" {
  count  = 1
  source = "github.com/s3d-club/terraform-aws-site?ref=v0.1.9"

  domain      = local.group.domain
  favicon     = null
  kms_key_arn = null
  name        = "go"
  s3_prefix   = local.group.name_prefix
  tags        = local.group.tags
}

module "mark_site" {
  count  = 0
  source = "github.com/s3d-club/terraform-aws-site?ref=v0.1.9"

  domain      = local.group.domain
  favicon     = null
  kms_key_arn = null
  name        = "mark"
  s3_prefix   = local.group.name_prefix
  tags        = local.group.tags
}

module "name" {
  source = "github.com/s3d-club/terraform-external-name?ref=v0.1.7"

  context = "s3d-account"
  path    = path.module
  tags    = {}
}

module "site" {
  count  = 1
  source = "github.com/s3d-club/terraform-aws-site?ref=v0.1.9"

  domain      = local.group.domain
  favicon     = null
  kms_key_arn = null
  tags        = local.group.tags
  s3_prefix   = local.group.name_prefix
}

# tfsec:ignore:aws-ec2-no-public-egress-sgr
# tfsec:ignore:aws-ec2-no-public-ingress-sgr
module "site_group" {
  source = "github.com/s3d-club/terraform-aws-site-group?ref=v0.1.27"

  cidr6s        = ["::/0"]
  cidrs         = ["0.0.0.0/0"]
  domain        = "s3d.club"
  name          = "s3d"
  ec2_key_name  = var.ec2_key_name
  ecrs          = ["python"]
  egress_cidr6s = ["::/0"]
  egress_cidrs  = ["0.0.0.0/0"]
  enable_ec2    = false
  kms_key_id    = null
  tags          = module.name.tags
  vpc_id        = data.aws_vpc.this.id
}
