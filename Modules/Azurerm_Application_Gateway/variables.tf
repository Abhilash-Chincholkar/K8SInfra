variable "agw" {
  type = map(object({
    agw_name = string
    resource_group_name = string
    location = string
  }))
}