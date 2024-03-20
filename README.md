
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=3.25.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.96.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_web_app.linux_web_app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_env"></a> [app\_env](#input\_app\_env) | The env name: dev, qa, test or prod | `string` | n/a | yes |
| <a name="input_app_prefix"></a> [app\_prefix](#input\_app\_prefix) | The 3 or 4 character mnemonic for the application name | `string` | n/a | yes |
| <a name="input_app_settings"></a> [app\_settings](#input\_app\_settings) | Application setting | `map(string)` | `{}` | no |
| <a name="input_application_stack"></a> [application\_stack](#input\_application\_stack) | Application stack configuration, run `az webapp list-runtimes --os-type linux` to get the list of supported stacks | `map(string)` | <pre>{<br>  "docker_image": "mcr.microsoft.comappsvc/staticsite:latest",<br>  "docker_image_tag": "latest"<br>}</pre> | no |
| <a name="input_asp_plan_id"></a> [asp\_plan\_id](#input\_asp\_plan\_id) | The ID of the app. service plan this functioan app needs to be deployed to | `string` | n/a | yes |
| <a name="input_container_registry_use_managed_identity"></a> [container\_registry\_use\_managed\_identity](#input\_container\_registry\_use\_managed\_identity) | site\_config block configuration option | `bool` | `true` | no |
| <a name="input_health_check_path"></a> [health\_check\_path](#input\_health\_check\_path) | Relative endpoint for the healthcheck resources. Ex: /health | `string` | `""` | no |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | List of user assigned identity IDs | `list(string)` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | The AZURE region location where this resource will be deployed to | `string` | n/a | yes |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | Should public network access be enabled for the Web App. Defaults to | `string` | `"true"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group name this private endpoint needs to be created in | `string` | n/a | yes |
| <a name="input_sub_prefix"></a> [sub\_prefix](#input\_sub\_prefix) | The 3 or 4 character mnemonic for this subscription | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | tags to be applied to resources | `map(string)` | `{}` | no |
| <a name="input_unique_name_string"></a> [unique\_name\_string](#input\_unique\_name\_string) | Provide this value if you want to create a unique name combination for this resource | `string` | `""` | no |
| <a name="input_virtual_network_subnet_id"></a> [virtual\_network\_subnet\_id](#input\_virtual\_network\_subnet\_id) | The outbound subnet that this app needs to be bound to | `string` | `null` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## IP Restrictions

In addition to the ip_restriction block and variable, there is also the `scm_ip_restriction`. These both appear to do the same thing. [Azurerm Resource](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app).

Here's example code for allowing certain IPs access to the web app when public access is not enabled:
```
    dynamic "ip_restriction" {
      for_each = var.ip_restriction
      content {
        name                      = ip_restriction.value.name
        ip_address                = ip_restriction.value.ip_address
        service_tag               = ip_restriction.value.service_tag
        virtual_network_subnet_id = ip_restriction.value.virtual_network_subnet_id
        priority                  = ip_restriction.value.priority
        action                    = ip_restriction.value.action
        dynamic "headers" {
          for_each = ip_restriction.value.headers
          content {
            x_azure_fdid      = headers.value.x_azure_fdid
            x_fd_health_probe = headers.value.x_fd_health_probe
            x_forwarded_for   = headers.value.x_forwarded_for
            x_forwarded_host  = headers.value.x_forwarded_host
          }
        }
      }
    }
```

```
variable "ip_restriction" {
  description = "Firewall settings for the web app"
  type = list(object({
    name                      = string
    ip_address                = optional(string, null)
    service_tag               = optional(string, null)
    virtual_network_subnet_id = optional(string, null)
    priority                  = optional(string, "100")
    action                    = string
    headers = optional(list(object({
      x_azure_fdid      = optional(list(string), null)
      x_fd_health_probe = optional(list(string), null)
      x_forwarded_for   = optional(list(string), null)
      x_forwarded_host  = optional(list(string), null)
    })), [])
  }))
  default = []
}
```
