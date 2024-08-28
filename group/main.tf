variable "identity_store_id" {
  type = string
}

variable "group" {
  type = string
}

variable "users" {
  type = list(string)
}

resource "aws_identitystore_group" "this" {
  identity_store_id = var.identity_store_id
  display_name      = var.group
  description       = "Group for ${var.group}"
}

data "aws_identitystore_user" "this" {
  for_each = toset(var.users)

  identity_store_id = var.identity_store_id

  alternate_identifier {
    unique_attribute {
      attribute_path  = "UserName"
      attribute_value = each.key
    }
  }
}

resource "aws_identitystore_group_membership" "this" {
  for_each = toset(var.users)

  identity_store_id = var.identity_store_id
  group_id          = aws_identitystore_group.this[each.key].group_id

  member_id = data.aws_identitystore_user.this[each.key].id
}
