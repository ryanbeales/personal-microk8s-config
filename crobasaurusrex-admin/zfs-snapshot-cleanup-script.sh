#!/bin/bash

# Remove the top 10 largest snapshots - don't do this for now, we've just migrated disks
#for i in $(zfs list -t snapshot -S used | head | tail -10 | cut -f1 -d\  ); do zfs destroy $i; done

# Scrub
sudo zpool scrub newpool