locals {
  app_settings  = {}
  location_abbr = { "westcentralus" : "wcus", "westus" : "wus", "westus2" : "wus2" }
  uniq_name     = length(regexall("[[:alnum:]]", chomp(trimspace(var.unique_name_string)))) < 1 ? "" : "${var.unique_name_string}-"
  tags = merge({
    "terraform" : "yes",
  }, var.tags)
  application_stack_struct = {
    docker_image        = null
    docker_image_tag    = null
    dotnet_version      = null
    java_server         = null
    java_server_version = null
    java_version        = null
    php_version         = null
    python_version      = null
    node_version        = null
    ruby_version        = null
  }
  application_stack = merge(local.application_stack_struct, var.application_stack)

}
