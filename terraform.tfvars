# terraform.tfvars

project_id = "ornate-node-483516-e3"

# These labels will be applied to every bucket created by this module
common_labels = {
  environment = "poc"
  managed_by  = "terraform"
  cost_center = "devops"
}

buckets = {
  # Example 1: A simple bucket using mostly default values
  "migration-landing-zone-bucket" = {
    location      = "asia-south1"
    storage_class = "STANDARD"
    versioning    = true
    labels = {
      data_type = "raw_ingestion"
    }
  },

  # Example 2: An advanced bucket demonstrating lifecycle rules
  "poc-archive-storage-bucket" = {
    location      = "asia-south1"
    storage_class = "NEARLINE"
    versioning    = true
    
    lifecycle_rules = [
      # Rule 1: Move items to COLDLINE storage after 30 days
      {
        action = {
          type          = "SetStorageClass"
          storage_class = "COLDLINE"
        }
        condition = {
          age = 30
        }
      },
      # Rule 2: Delete old non-current versions of files after 90 days to save space
      {
        action = {
          type = "Delete"
        }
        condition = {
          days_since_noncurrent_time = 90
        }
      }
    ]
  }
}