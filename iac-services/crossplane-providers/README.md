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
