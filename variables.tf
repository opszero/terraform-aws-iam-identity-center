
variable "users" {
  type = map(object({
    first_name = string
    last_name  = string
  }))
}

variable "groups" {
  type = map(object({
    description = string
    users       = list(string)
  }))
}

variable "accounts" {
  description = "List of AWS accounts to create with enabled flag"
  type = list(object({
    name                       = string
    email                      = string
    enabled                    = optional(bool, false)
    close_on_deletion          = optional(bool, false)
    create_govcloud            = optional(bool, false)
    iam_user_access_to_billing = optional(string, "ALLOW")
    role_name                  = optional(string)
    tags                       = optional(map(string), {})
  }))
  default = []
}