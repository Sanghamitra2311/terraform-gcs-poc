resource "google_storage_bucket" "buckets" {
  for_each = var.buckets

  name          = each.key
  project       = var.project_id
  
  # Uses specific location if provided, otherwise defaults to root Terragrunt region
  location      = each.value.location
  storage_class = each.value.storage_class

  # ---------------------------------------------------------------------
  # TERRAFORM LIFECYCLE: Prevents accidental deletion of the bucket itself
  # ---------------------------------------------------------------------
  lifecycle {
    prevent_destroy = true
  }

  versioning {
    enabled = each.value.versioning
  }

  # Merges the global labels with any specific labels defined per bucket
  labels = merge(var.common_labels, each.value.labels)

  # ---------------------------------------------------------------------
  # GCP LIFECYCLE RULES: Manages the objects/files inside the bucket
  # ---------------------------------------------------------------------
  dynamic "lifecycle_rule" {
    for_each = each.value.lifecycle_rules
    content {
      action {
        type          = lifecycle_rule.value.action.type
        storage_class = lifecycle_rule.value.action.storage_class
      }
      condition {
        age                        = lifecycle_rule.value.condition.age
        created_before             = lifecycle_rule.value.condition.created_before
        with_state                 = lifecycle_rule.value.condition.with_state
        matches_storage_class      = lifecycle_rule.value.condition.matches_storage_class
        num_newer_versions         = lifecycle_rule.value.condition.num_newer_versions
        days_since_noncurrent_time = lifecycle_rule.value.condition.days_since_noncurrent_time
      }
    }
  }
}