Create the deploy key:
```
ssh-keygen -t ecdsa -f deploykey
```
Note: default ssh-keygen creates keys that are not allowed.

Create an argocd repository (this command doesn't format correctly, but you get the idea):
```
cat << EOF | sudo k3s kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: k8s-config-repo
  namespace: argocd
  labels:
    argocd.argoproj.io/secret-type: repository
stringData:
  type: git
  url: git@github.com:ryanbeales/personal-microk8s-config.git
  sshPrivateKey: |-
    $(cat deploykey)
EOF
```

Add the public key to personal_microk8s_config repo as a deploy key in settings.

Get the admin username to login with:
```
sudo k3s kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```