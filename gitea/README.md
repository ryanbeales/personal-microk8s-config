Local gitea instance for CI/CD and local package repo. Intent is to mirror github repos and build locally for deployment in the same cluster.

Prereqisite:
Create the admin username and password with this:
```
sudo k3s kubectl create namespace gitea # Created here to store the secret, but will be managed by the helm chart afterwards.
sudo k3s kubectl create secret generic -n gitea gitea-admin-secret --from-literal=password=$(openssl rand -base64 16) --from-literal=username=YOUR_NAME_HERE
```

Then on the host create the filesystem directory as the persistant volume will not create it itself.
```
mkdir -p /stash/gitea
```