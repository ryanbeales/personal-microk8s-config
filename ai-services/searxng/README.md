Create secret for local encryption:
```
sudo k3s kubectl create secret generic -n searxng searxng-secret --from-literal=SEARXNG_SECRET=$(openssl rand -base64 12)
```


After Searxng has started, edit the settings file to enable json format. In future, just save it as a configmap here.