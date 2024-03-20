locals {
  app_settings  = {}
  location_abbr = { "westcentralus" : "wcus", "westus" : "wus", "westus2" : "wus2" }
  uniq_name     = length(regexall("[[:alnum:]]", chomp(trimspace(var.unique_name_string)))) < 1 ? "" : "${var.unique_name_string}-"
  tags = merge({
    "terraform" : "yes",
  }, var.tags)
  application_stack_struct = {}
  application_stack        = merge(local.application_stack_struct, var.application_stack)
}
