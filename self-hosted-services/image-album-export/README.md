Tool to export a named immich album to a folder of files https://github.com/ryanbeales/immich-album-export

Used to populate the digital photo frame NFS share where [feh](https://feh.finalrewind.org/) will pick it up.

There will be one cronjob per api-key and album combo.

Within immich create an API key with the following permissions
```
album.download
album.read
asset.download
```

Save the API key in a k8s secret with:
```
sudo k3s kubectl create secret generic -n immich-album-export immich-ryan-apikey --from-literal=IMMICH_API_KEY={APIKEY}
```