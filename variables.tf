
variable "users" {
  type = map(object({
    email      = string
    first_name = string
    last_name  = string
  }))
}
