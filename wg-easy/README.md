- Manually set up port forwarding in router
- Manually set up DNS entry in route53 to avoid leaking IP publically via this repo.

TODO:
- Find a UPNP client that can set the port forwarding automagically (miniupnpc? But it can't discover the device when inside docker.)
- Find a DNS update that can set the ip automagically (aws client?)