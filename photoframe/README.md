This will eventually be:
- Running the photoframe software from within a container on to a devices display
- The NFS server which is the source of images for the slideshow


For now, this is just the NFS server part, the slideshow runs on the device with this systemd unit (we could just create that with a container too):
```
[Unit]
Description=feh slideshow
PartOf=graphical.target
After=graphical.target

[Service]
Type=exec
Restart=no
ExecStartPre=/usr/bin/sleep 30
ExecStart=/usr/bin/feh -Z -F -Y --on-last-slide resume --randomize --recursive --reload 86400 --slideshow-delay 20.0 -- /PiFrame/Photos
```


There are also these additional systemd units to help with the slideshow:
Turn screen on
```
[Unit]
Description=Turn Screen On

[Service]
Type=oneshot
ExecStart=/usr/bin/bash -c 'echo 255 > /sys/class/backlight/10-0045/brightness'
```
Turn screen on timer
```
[Unit]
Description=Turn screen on at 7am

[Timer]
OnCalendar=*-*-* 07:30:00

[Install]
WantedBy=timers.target
```

Turn screen off
```
[Unit]
Description=Turn Screen Off

[Service]
Type=oneshot
ExecStart=/usr/bin/bash -c 'echo 0 > /sys/class/backlight/10-0045/brightness'
```
Turn screen off timer
```
[Unit]
Description=Turn screen off at 10pm

[Timer]
OnCalendar=*-*-* 22:00:00

[Install]
WantedBy=timers.target
```