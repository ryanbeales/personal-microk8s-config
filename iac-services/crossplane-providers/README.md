## AWS Provider Setup

IAM role already exists: arn:aws:iam::{account}:user/crossplane-k3s - has full S3, EC2 and Route53 access
Create a new access key and secret for crossplane in this user.

Create a file like below named aws-credentials.txt:
```
[default]
aws_access_key_id = 
aws_secret_access_key = 
```

Create secret from credentials:
```
sudo k3s kubectl create secret generic aws-secret -n crossplane-system --from-file=creds=./aws-credentials.txt
```

More details on the process here if needed:
https://docs.crossplane.io/latest/getting-started/provider-aws/#generate-an-aws-key-pair-file

## GCP Provider Setup

1. Create a Service Account `crossplane-sa` in the `k8sgemini` project with `Editor` permissions [here](https://console.cloud.google.com/iam-admin/serviceaccounts?project=k8sgemini)
2. Create and download a JSON key for the Service Account.
3. Create the secret in Kubernetes:

```bash
kubectl create secret generic gcp-secret -n crossplane-system --from-file=creds=./path-to-your-gcp-key.json
```
