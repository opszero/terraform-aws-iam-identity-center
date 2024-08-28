locals {
  instance_arn      = tolist(data.aws_ssoadmin_instances.this.arns)[0]
  identity_store_id = tolist(data.aws_ssoadmin_instances.this.identity_store_ids)[0]
}

data "aws_ssoadmin_instances" "this" {}

# data "aws_ssoadmin_permission_set" "readonly" {
#   instance_arn = local.instance_arn
#   name         = "AWSReadOnlyAccess"
# }

# resource "aws_ssoadmin_account_assignment" "this" {
#   instance_arn       = local.instance_arn
#   permission_set_arn = data.aws_ssoadmin_permission_set.this.arn

#   principal_id   = data.aws_identitystore_group.this.group_id
#   principal_type = "GROUP"

#   target_id   = "123456789012"
#   target_type = "AWS_ACCOUNT"
# }



resource "aws_identitystore_user" "this" {
  for_each = var.users

  identity_store_id = local.identity_store_id
  display_name      = "${each.value.first_name} ${each.value.last_name}"
  user_name         = each.key

  emails {
    primary = true
    value   = each.key
  }

  name {
    family_name = each.value.last_name
    given_name  = each.value.first_name
  }
}

module "groups" {
  for_each = var.groups
  source   = "./group"

  identity_store_id = local.identity_store_id
  group             = each.key
  users             = each.value.users

  depends_on = [aws_identitystore_user.this]
}
