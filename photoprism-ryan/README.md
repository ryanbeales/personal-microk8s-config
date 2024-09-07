Docs here:
https://docs.photoprism.app/getting-started/advanced/kubernetes/

Argocd should take care of _almost_ everything.

Start the manual stuff from here:

Create secrets:
```
PHOTOPRISM_DB_PASSWORD=$(openssl rand -base64 12)

sudo k3s kubectl create secret generic -n photoprism-ryan photoprism-db-secrets --from-literal=MARIADB_ROOT_PASSWORD=$(openssl rand -base64 12) --from-literal=MARIADB_USER=photoprism --from-literal=MARIADB_PASSWORD=${PHOTOPRISM_DB_PASSWORD} --from-literal=MARIADB_DATABASE=photoprism
sudo k3s kubectl create secret generic -n photoprism-ryan photoprism-secrets --from-literal=PHOTOPRISM_ADMIN_PASSWORD=$(openssl rand -base64 12) --from-literal=PHOTOPRISM_DATABASE_DSN="photoprism:${PHOTOPRISM_DB_PASSWORD}@tcp(photoprism-db.photoprism-ryan:3306)/photoprism?charset=utf8mb4,utf8&parseTime=true"
```


Get admin password:

On first startup:
```
k get secrets/photoprism-secrets -n photoprism-ryan -o json | jq -r '.data.PHOTOPRISM_ADMIN_PASSWORD' | base64 -d
```

On subsequent starts you'll need to get it from photoprism itself: