
variable "users" {
  type = list(object({
    display_name = string
    email        = string
    family_name  = string
    given_name   = string
  }))
}
