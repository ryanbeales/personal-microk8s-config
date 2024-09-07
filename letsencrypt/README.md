1. Get access key for crobasaurusrex aws user in IAM console, add access key to clusterissuer.yaml, record the values in the command below.

1. Create secret for aws access key:
```
sudo k3s kubectl create secret generic aws-route53-creds --from-literal=aws-access-key-id={secret} --from-literal=access-key-secret={secret} -n cert-manager
```