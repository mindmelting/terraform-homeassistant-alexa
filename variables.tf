variable "ha_url" {
  type = string
}
variable "ha_bearer_token" {
  type      = string
  sensitive = true
}

variable "alexa_skill_id" {
  type = string
}
