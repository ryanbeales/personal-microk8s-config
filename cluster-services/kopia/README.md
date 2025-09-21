Backups are now handled by kopia. Moved from duplicati+s3 to kopia+eazybackup.ca for storage in Canada (and to send less money to the US via AWS...)

Manually created a bucket via the eazybackup UI named kopia-backups

Create a username and password for the UI:
```
sudo k3s kubectl create secret generic kopia-server-secret --from-literal=SERVER_USERNAME=admin --from-literal=SERVER_PASSWORD=$(openssl rand -base64 12) -n kopia
```

Save the repository password in a secret:
```
sudo k3s kubectl create secret generic kopia-repository-secret --from-literal=KOPIA_PASSWORD={secret} -n kopia
```

To configure the eazybackup respository you need to configure this via the pod (`sudo k3s kubectl exec -it `...)
Service URL is s3.ca-central-1.eazybackup.com
Create and access key manually, you'll use this in the command below
Throttling is set at 100Mbit upload, and 400Mbit download (connection is 2Gbit/200Mbit up/down)

The commands are:
```
kopia repository create s3 --bucket=kopia-crobasaurusrex-backups --access-key={SECRET} --secret-access-key={SECRET} --endpoint=s3.ca-central-1.eazybackup.com --override-hostname=kopia-k3s-crobasaurusrex
kopia repository throttle set --download-bytes-per-second=50000000 --upload-bytes-per-second=12500000 --concurrent-reads=8 --concurrent-writes=8
```

Then login after a restart to use the server UI and configure the backups
