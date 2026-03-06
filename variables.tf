# --- Module-specific variables ---
variable "project_id" {
  description = "The GCP project ID where the buckets will be created"
  type        = string
}

variable "common_labels" {
  description = "A map of labels to apply to all buckets"
  type        = map(string)
  default     = {}
}

variable "buckets" {
  description = "Map of GCS buckets to create with their specific configurations."
  type = map(object({
    location      = optional(string, "asia-south1") # Fallback to var.region if omitted
    storage_class = optional(string, "STANDARD")
    versioning    = optional(bool, true)
    labels        = optional(map(string), {})
    lifecycle_rules = optional(list(object({
      action = object({
        type          = string
        storage_class = optional(string)
      })
      condition = object({
        age                        = optional(number)
        created_before             = optional(string)
        with_state                 = optional(string)
        matches_storage_class      = optional(list(string))
        num_newer_versions         = optional(number)
        days_since_noncurrent_time = optional(number)
      })
    })), []) # Defaults to an empty list, making it fully optional
  }))
}
