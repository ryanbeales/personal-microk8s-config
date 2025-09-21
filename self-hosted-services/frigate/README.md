Create secrets for cameras:
```
sudo k3s kubectl create secret generic -n frigate reocam-password --from-literal=FRIGATE_REOCAM_PASSWORD={PASSWORD HERE}
sudo k3s kubectl create secret generic -n frigate armcrest-front-password --from-literal="FRIGATE_ARMCREST_FRONT_PASSWORD={PASSWORD_HERE}"
```

Secrets for substitution must start with `FRIGATE_` according to this https://docs.frigate.video/configuration/#environment-variable-substitution

Full docs for frigate are here https://docs.frigate.video/
Repo for bugs and other things is here https://github.com/blakeblackshear/frigate