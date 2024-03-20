variable "app_env" {
  type        = string
  nullable    = false
  description = "The env name: dev, qa, test or prod"
}
variable "app_prefix" {
  type        = string
  nullable    = false
  description = "The 3 or 4 character mnemonic for the application name "
}
variable "application_stack" {
  type = map(string)
  default = {
    docker_image     = "mcr.microsoft.comappsvc/staticsite:latest"
    docker_image_tag = "latest"
  }
  description = "Application stack configuration, run `az webapp list-runtimes --os-type linux` to get the list of supported stacks"
}
variable "health_check_path" {
  type        = string
  nullable    = true
  description = "Relative endpoint for the healthcheck resources. Ex: /health"
  default     = ""
}
variable "identity_ids" {
  type        = list(string)
  description = "List of user assigned identity IDs"
  default     = null
}
variable "location" {
  type        = string
  nullable    = false
  description = "The AZURE region location where this resource will be deployed to"
}
variable "public_network_access_enabled" {
  type        = string
  description = "Should public network access be enabled for the Web App. Defaults to"
  default     = "true"
}
variable "resource_group_name" {
  type        = string
  nullable    = false
  description = "The resource group name this private endpoint needs to be created in"
}
variable "sub_prefix" {
  type        = string
  nullable    = false
  description = "The 3 or 4 character mnemonic for this subscription"
}
variable "tags" {
  description = "tags to be applied to resources"
  type        = map(string)
  default     = {}
}
variable "unique_name_string" {
  description = "Provide this value if you want to create a unique name combination for this resource"
  type        = string
  nullable    = true
  default     = ""
}
variable "virtual_network_subnet_id" {
  type        = string
  nullable    = false
  description = "The outbound subnet that this app needs to be bound to"
}