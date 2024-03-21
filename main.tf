resource "azurerm_linux_web_app" "linux_web_app" {
  name                          = "as-${local.uniq_name}${var.sub_prefix}-${var.app_prefix}-${var.app_env}-${local.location_abbr[var.location]}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  service_plan_id               = var.asp_plan_id
  https_only                    = true
  app_settings                  = merge(local.app_settings, var.app_settings)
  virtual_network_subnet_id     = var.virtual_network_subnet_id
  public_network_access_enabled = var.public_network_access_enabled

  tags = local.tags

  identity {
    type         = var.identity_ids == null ? "SystemAssigned" : "SystemAssigned, UserAssigned"
    identity_ids = var.identity_ids
  }

  site_config {
    always_on                               = true # This does not work with the "free" (F1) sku
    container_registry_use_managed_identity = var.container_registry_use_managed_identity
    health_check_path                       = var.health_check_path

    application_stack {
      docker_registry_url = local.application_stack["docker_registry_url"]
      docker_image_name   = local.application_stack["docker_image_name"]
    }
  }

  lifecycle {
    ignore_changes = [
      site_config[0].application_stack,
      app_settings,
    ]
  }
}

resource "azurerm_app_service_custom_hostname_binding" "custom_hostname" {
  count = var.hostname != null || var.hostname != "" ? 1 : 0 # Only create the resource if hostname is provided

  hostname            = var.hostname
  app_service_name    = azurerm_linux_web_app.linux_web_app.name
  resource_group_name = var.resource_group_name
}