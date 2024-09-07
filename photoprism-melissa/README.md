We have two photoprisms because at the time I set this up it did not support accounts.

Docs here:
https://docs.photoprism.app/getting-started/advanced/kubernetes/

Argocd should take care of _almost_ everything.

Start the manual stuff from here:

Create secrets:
```
PHOTOPRISM_DB_PASSWORD=$(openssl rand -base64 12)

sudo k3s kubectl create secret generic -n photoprism-melissa photoprism-db-secrets --from-literal=MARIADB_ROOT_PASSWORD=$(openssl rand -base64 12) --from-literal=MARIADB_USER=photoprism --from-literal=MARIADB_PASSWORD=${PHOTOPRISM_DB_PASSWORD} --from-literal=MARIADB_DATABASE=photoprism
sudo k3s kubectl create secret generic -n photoprism-melissa photoprism-secrets --from-literal=PHOTOPRISM_ADMIN_PASSWORD=$(openssl rand -base64 12) --from-literal=PHOTOPRISM_DATABASE_DSN="photoprism:${PHOTOPRISM_DB_PASSWORD}@tcp(photoprism-db.photoprism-melissa:3306)/photoprism?charset=utf8mb4,utf8&parseTime=true"
```

If the database already exists on disk, then the database passwords will be reset by the init-container on startup.


Get admin password:
```
sudo k3s kubectl get secrets/photoprism-secrets -n photoprism-melissa -o json | jq -r '.data.PHOTOPRISM_ADMIN_PASSWORD' | base64 -d
```


Recovery:
Get in to the init container and:
```
cd /var/lib/mysql
mv ibdata1 ibdata1.orig
mv ib_logfile0 ib_logfile0.orig
runuser -l mysql -c '/usr/sbin/mariadbd &'
```
Recovery will happen without the log files and the database will start

Debugging startup:
Create a debug pod based on the same config:
```
k debug photoprism-5f5f66488b-sz4rp -n photoprism-melissa --image photoprism/photoprism:230719 -it --copy-to=photoprism-debug --share-processes -- /bin/bash
```

Execute the following to check if there are any pending migrations:
```
photoprism migrations ls
```

If there are run the start up to see if they complete:
```
photoprism start
```

Delete the debug container when done:
```
k delete pod photoprism-debug -n photoprism-melissa
```


mariadb-dump photoprism --user=$MARIADB_USER --password=$MARIADB_PASSWORD --single-transaction