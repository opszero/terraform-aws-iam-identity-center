locals {
  instance_arn      = tolist(data.aws_ssoadmin_instances.example.arns)[0]
  identity_store_id = tolist(data.aws_ssoadmin_instances.example.identity_store_ids)[0]
}

data "aws_ssoadmin_instances" "this" {}

data "aws_identitystore_group" "this" {
  identity_store_id = local.identity_store_id

  alternate_identifier {
    unique_attribute {
      attribute_path  = "DisplayName"
      attribute_value = "ExampleGroup"
    }
  }
}

data "aws_ssoadmin_permission_set" "readonly" {
  instance_arn = local.instance_arn
  name         = "AWSReadOnlyAccess"
}


resource "aws_ssoadmin_account_assignment" "this" {
  instance_arn       = local.instance_arn
  permission_set_arn = data.aws_ssoadmin_permission_set.this.arn

  principal_id   = data.aws_identitystore_group.this.group_id
  principal_type = "GROUP"

  target_id   = "123456789012"
  target_type = "AWS_ACCOUNT"
}

resource "aws_identitystore_user" "this" {
  for_each = var.users

  identity_store_id = local.identity_store_id
  display_name      = each.value.display_name
  user_name         = each.value.email

  name {
    family_name = each.value.family_name
    given_name  = each.value.given_name
  }
}

resource "aws_identitystore_group" "this" {
  identity_store_id = local.identity_store_id
  display_name      = "MyGroup"
  description       = "Some group name"
}

resource "aws_identitystore_group_membership" "this" {
  identity_store_id = local.identity_store_id
  group_id          = aws_identitystore_group.example.group_id
  member_id         = aws_identitystore_user.example.user_id
}
