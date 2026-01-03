---
description: follow rules for manifest structure and organization
---
# Manifest Structure and Organization

When creating or modifying Kubernetes manifests (including Crossplane resources), follow these rules:

1. **One Manifest Per File**: Each `.yaml` file should contain exactly one Kubernetes resource. Do not use `---` to separate multiple manifests in a single file unless it is absolutely necessary for atomic application (rare).
2. **Resource Grouping**: Group related resources into subdirectories. For example:
   - DNS records in `dns/`
   - CloudFront distributions in `cloudfront/`
   - ACM certificates in `acm/`
3. **Provider Configuration**: Split Crossplane providers into individual files named `provider-<family>.yaml` or similar.
4. **Naming Convention**: 
   - Files should be named descriptively based on the resource they contain (e.g., `distribution.yaml`, `certificate.yaml`).
   - For DNS, using the domain name or record purpose is acceptable (e.g., `www.ryanbeales.com.yaml`).
