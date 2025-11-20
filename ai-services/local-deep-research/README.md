Create secret for local encryption:
```
sudo k3s kubectl create secret generic -n searxng searxng-secret --from-literal=SEARXNG_SECRET=$(openssl rand -base64 12)
```