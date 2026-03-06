# terraform-gcs-poc
# Terraform GCS Bucket Module (Terragrunt Optimized)

A lightweight, loopable Terraform module to provision and manage multiple Google Cloud Storage (GCS) buckets. This module is designed to be called via Terragrunt and automatically inherits provider configurations (`region`, `org_id`, `billing_account`) from a root `common.hcl`.

## 🚀 Features

* **Multi-Bucket Provisioning:** Uses a single `for_each` loop to create multiple buckets from one configuration block.
* **Smart Defaults:** Automatically defaults to `STANDARD` storage class and enables `versioning` unless explicitly overridden.
* **Dynamic Lifecycle Rules:** Fully optional object lifecycle management (e.g., transition to Nearline, delete old versions).
* **Label Merging:** Applies global `common_labels` to all buckets while allowing bucket-specific label overrides.
* **Built-in Protection:** Enforces `prevent_destroy = true` on the bucket infrastructure to prevent accidental data loss.

## ⚠️ Important Note on Deletion
This module hardcodes `lifecycle { prevent_destroy = true }` on the GCS bucket resource. If you intentionally need to destroy a bucket via Terragrunt, you must temporarily comment out this block in the module source code first.

## Screenshot 
Buckets created via Terraform 
<img width="1911" height="985" alt="image" src="https://github.com/user-attachments/assets/60bf5fff-c0e9-48c3-bdeb-d51462fa16c8" />

<img width="1919" height="402" alt="image" src="https://github.com/user-attachments/assets/2ef1bbdd-2b70-4629-ac34-c910bc1a6b3a" />
<img width="1666" height="442" alt="image" src="https://github.com/user-attachments/assets/b4df8a3c-c462-4048-a7d4-927bc65b8ac9" />
<img width="1911" height="1009" alt="image" src="https://github.com/user-attachments/assets/8d48d5f3-186e-4909-8648-f8c04da3e875" />
<img width="1908" height="1012" alt="image" src="https://github.com/user-attachments/assets/8e650b42-c6a4-47d1-8263-5828853a47ce" />
<img width="1916" height="905" alt="image" src="https://github.com/user-attachments/assets/b63bcb1f-bf07-4119-a247-21069ae911e0" />
<img width="1546" height="850" alt="image" src="https://github.com/user-attachments/assets/27abbdea-aa56-4e5f-8ba4-358ac7e5699c" />





## 💻 Example Usage (Terragrunt)

Create a `terragrunt.hcl` file in your component directory and pass the required inputs. 

```hcl
include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://your-repo-url/modules/gcs-buckets?ref=v1.0.0" 
}

inputs = {
  project_id = "your-target-project-id"

  common_labels = {
    managed_by  = "terragrunt"
    environment = "staging"
  }

  buckets = {
    # Example 1: Basic bucket inheriting defaults (Standard class, versioning enabled, default region)
    "aws-to-gcp-migration-staging-data" = {
      labels = { purpose = "migration-transfer" }
    }

    # Example 2: Archival bucket with custom region, disabled versioning, and lifecycle rules
    "aws-to-gcp-migration-archive" = {
      location      = "asia-east1"
      storage_class = "NEARLINE"
      versioning    = false
      
      lifecycle_rules = [
        {
          action = {
            type = "Delete"
          }
          condition = {
            age = 365
          }
        }
      ]
    }
  }
}
