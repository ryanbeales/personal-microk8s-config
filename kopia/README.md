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

Then login after deploy to use the server UI.


To configure the eazybackup respository:
Service URL is s3.ca-central-1.eazybackup.com
Create and access key manually, you'll use this to configure the Kopia UI
This needs a repository password - mine is saved in vaultwarden for this repository.
