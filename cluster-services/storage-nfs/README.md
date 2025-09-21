Provides NFS storage to pods in the rest of the cluster.

There are two parts:
- nfs-server to export a local filesystem as NFS
- csi-driver-nfs to automatically provision PVs in the NFS server as directories under the main nfs export.

We'll use the local `/stash` volume on crobasaurusrex (zfs mirrored on 20TB disks) for nfs-server. Kopia has `/stash` mounted and will back up all items below, including this.