Create secret for postgres:
```
sudo k3s kubectl create secret generic -n immich immich-postgres-secrets --from-literal=password=$(openssl rand -base64 12) --from-literal=postgres-password==${PHOTOPRISM_DB_PASSWORD}
```