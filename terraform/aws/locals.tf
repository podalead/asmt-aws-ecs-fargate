locals {
  prefix = var.profile == "prod" ? "" : "${var.prefix}-"
}