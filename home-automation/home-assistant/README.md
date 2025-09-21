Do zwavejs install first. Configure via its UI.

Then:
Once you login and create an owner account, add zwavejs and the address will be ws://zwavejs2mqtt:3000

Then:
Add devices in z-wavejs or home assistant. They will appear and you can add functions to the dashboard.

Nest integration, follow this: https://www.home-assistant.io/integrations/nest/ (sets up an api key to call the nest apis)

Meross integration, follow this: https://github.com/albertogeniola/meross-homeassistant (Install HACS in home-assistant, then install the meross plugins and configure same as the app)


If you want auto discovery of devices from home assistant, then you need to enable an mDNS reflector. On the hosts where home assistant can run:
```
sudo apt-get update
sudo apt-get install avahi-daemon
```

Then edit `/etc/avahi/avahi-daemon.conf` to enable the reflector:
```
[reflector]
enable-reflector=yes
reflect-ipv=no
```

This will enable mDNS traffic from all pods (ie: interafaces) running on the node. 

THANKS https://blog.warrenamphlett.co.uk/homelab/home-assistant-in-kubernetes !! While this blog refers to VLANS to separate off smart devices, I unfortunatly don't have smart enough networking to do that yet. So I just needed the reflector on the host.