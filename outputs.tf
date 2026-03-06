output "bucket_names" {
  description = "A map of the bucket keys to their actual names"
  value       = { for k, v in google_storage_bucket.buckets : k => v.name }
}

output "bucket_urls" {
  description = "A map of the bucket keys to their URIs"
  value       = { for k, v in google_storage_bucket.buckets : k => v.url }
}