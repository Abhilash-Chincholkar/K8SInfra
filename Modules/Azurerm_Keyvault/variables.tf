variable "keyvaults" {
    type = map(object({
        kv_name = string
        location = string
        resource_group_name = string
        
    }))
}