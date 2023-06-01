variable "defaults" {
  description = "Map of default values that will be used for each provided item."
  type        = any
  default     = {}
}

variable "items" {
  description = "Maps of items to create a wrapper from. Values placed in this variable are passed to the Terragrunt module."
  type        = any
  default     = {}
}
