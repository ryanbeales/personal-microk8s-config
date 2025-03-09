Backups are now handled by kopia. Moved from duplicati+s3 to kopia+eazybackup.ca for storage in Canada (and to send less money to the US via AWS...)

Manually created a bucket via the eazybackup UI named kopia-backups

Service URL is s3.ca-central-1.eazybackup.com

Create and access key manually, and save as a k8s secret:
```
sudo k3s kubectl create secret generic eazybackup-access-key --from-literal=access-key-id={secret} --from-literal=access-key-secret={secret} -n kopia
```