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


Notes for my future self:
I'm using the ZHA zigbee add on in home assistant. I have some [Sonoff ZBMINIL2](https://sonoff.tech/pages/user-manual?srsltid=AfmBOooZUkoZ1UbUdYLhp-JRWdLH9IZmgY40za1bD-Y9QiAR1V2IbC76) switches. _One_ of them will lose contact with the host and start switching itself on and off randomly. This is on a light switch over the front door, it looks like we're trying to communicate morse code to our neighbours.

To fix this you can do these things:
- Update the [firmware of the adapater](https://dongle.sonoff.tech/sonoff-dongle-flasher/). I have the Sonoff ZBDongle-P (NOT the E!), but this page should find the correct firmware and load it. After this you might have to "migrate to a new adapter" in the ZHA integration in home assistant.
- Turn the light switch on and off 10 times, this will reset the firmware. You can tell it worked because the switch won't trigger the internal relay anymore. Remove the device and then add a new zigbee device and it'll be found again with the same settings in home assistant. Time lost here: 12 hours.