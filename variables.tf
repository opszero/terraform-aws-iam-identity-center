
variable "users" {
  type = map(object({
    first_name = string
    last_name  = string
    groups     = list(string)
  }))
}
