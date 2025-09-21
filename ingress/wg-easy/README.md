- Manually set up port forwarding in router
- Manually set up DNS entry in route53 to avoid leaking IP publically via this repo.
- Create an admin secret:
```
sudo k3s kubectl create secret generic wg-easy-secrets --from-literal=wg-easy-admin-password=$(openssl rand -base64 20) -n wg-easy
```
- Use the secret to login.

TODO:
- Find a UPNP client that can set the port forwarding automagically (miniupnpc? But it can't discover the device when inside docker.)
- Find a DNS update that can set the ip automagically (aws client?)