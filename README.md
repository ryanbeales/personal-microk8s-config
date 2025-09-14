Welcome to my home kubernetes configuration!

## FAQs which are not asked frequently or otherwise, and also one isn't even a question

### What is this?
This is my home kubernetes configuration!

### Why would you make it public?
It's a demo showing I can run kubernetes and use it everyday. Am I in danger? I think this is all OK. We'll find out I guess.

### Is it any good?
Not really. It's always a work in progress and lots of things aren't commented to a standard I would leave in the workplace since this is just my home. Some not great stuff in here but it works and working is better than not working. It's been _much_ easier to maintain than stand alone systems. It use to have a lot of k8s-at-home helm charts but they shut that down so I just went back to plain manifests. I find it easier to have the plain manifests than trying to find out what a helm chart does anwyay. NixOS seems to be flavour of the month now but given I work every day with Kubernetes this just comes easier.

### Why does it say microk8s when you refer to k3s elsewhere?
Because it was! But one day the "distributed sqllite" that's built in to microk8s suddenly died. I didn't mind microk8s until this point, it kept itself up to date worked reasonably well. But one day it died and I was sad. So instead I removed microk8s and switched over to k3s which turned out to be incredibly easy and allowed me to add my rasperry pi's in to the cluster as well. 

### But why would the distributed sqlite in microk8s break?
I think the culprit was actually Tekton and the many many leases it tries to keep which were killing the database performance. Anyway, this is a home server, it didn't matter that much but when I switched to k3s it was surprisingly easy.

### My eyes! I looked at the commit history!
Ah this is the one that's not the question. Correct it's pretty horrible. It's just me, I push direct to main and I often don't know what I'm doing so I push it up in to the environment and see what works. But now that the nightmare of configuring Frigate is over we can move on to some other batch of commits then. It's my day job to fix this kind of workflow but sometimes I don't want to bring my work home either (even though it's just a slight head turn since it's the same desk). [Edit: Well not this looks out of place since I cleaned up the history to remove any secret references that have crept in over time...]

### Why run Kubernetes at home?
1. Work.
1. I took inspiration from here https://github.com/billimek/k8s-gitops/tree/master/default, however I've not referred to that in a long time now.
1. Seemed like an easy way to manage home assistant and other software.

## Bootstrap
If it breaks again, start here.
1. On master node `curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable traefik" sh -s -`
1. Get the token from the master node `cat /var/lib/rancher/k3s/server/node-token`

1. On other nodes `curl -sfL https://get.k3s.io | K3S_URL=https://10.0.0.59:6443 K3S_TOKEN=${K3S_TOKEN} sh -s -`
1. On GPU nodes follow the driver install in the nvidia-gpu readme.
1. On all nodes make a `/stash` directory for local storage provisioning.
1. Check that `/stash` is in the `kube-system/local-path-config` configmap - K3s may change this. It's an issue at the moment but we will look at that later.

All the rest of these steps are on the on master node
1. Install kustomize, on ubuntu that is `curl -L https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv5.3.0/kustomize_v5.3.0_linux_amd64.tar.gz --output - | tar xzf - kustomize | sudo mv kustomize /usr/local/bin/kustomize`
1. Install helm `curl https://get.helm.sh/helm-v3.14.2-linux-amd64.tar.gz --output - | tar xzf - linux-amd64/helm | sudo mv linux-amd64/helm /usr/local/bin/helm`
1. Install github client `sudo apt-get install gh`
1. Authenticate gh client `/usr/bin/gh auth login` and follow instructions. Use SSH not http.
1. Checkout this repo to the master node `/usr/bin/gh repo clone ryanbeales/personal-microk8s-config`
1. Install cert-manager with `/usr/local/bin/kustomize build cert-manager | sudo k3s kubectl apply -f -`
1. Create route53 secret access, see `./letsencrypt/README.md`
1. Add letsencrypt certificate issuer `/usr/local/bin/kustomize build letsencrypt | sudo k3s kubectl apply -f -`
1. Install ingress-nginx `/usr/local/bin/kustomize build ingress-nginx --enable-helm --helm-command /usr/local/bin/helm | sudo k3s kubectl apply -f -`
1. Install argocd with kustomize `/usr/local/bin/kustomize build argocd | sudo k3s kubectl apply -f -` - ignore CRD errors, the apps will be picked up after the secret is applied.
1. Follow argocd readme to create argocd repo secret.
1. At this point the rest of the cluster will then come up as best it can.
1. Created passwords for octoprint, photoprism, crossplane-providers, this will start these applications correctly.

Notes:
- The crossplane provider config `crossplane-providers/aws-provider-config.yaml` will not apply until other objects have applied first. You may have to remove this and add in the next sync. I'm not a fan of how this all works but we'll leave it in place for now.
- There may be some missing steps. Usually the README in each directory will explain what to do if the project goes wrong.

## Adding windows nodes
I have a gaming PC with a hefty nvidia card in it. I can install K3s via WSL on this PC to make it available to the cluster when I'm not gaming (often, these days).

On the windows PC (these may or may not be in order or complete)
1. Create a .wslconfig in your user directory:
```
[wsl2]
networkingMode=bridged
vmSwitch=WSL Switch
dnsTunneling = false
firewall = false

[network]
generateResolvConf = false
```
1. Install wsl2 `wsl --install` or reinstall (https://gist.github.com/4wk-/889b26043f519259ab60386ca13ba91b), hyper-v and hyper-v manager
1. Create a new External switch in hyper-v manager named `WSL-Switch`, connect it to your network interface
1. Install and Start the Ubuntu instance `wsl --install Ubuntu`
1. Install k3s node as above in the Bootstrap section
1. Install cuda on wsl2 https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html
1. Restart the k3s agent `sudo systemctl restart k3s-agent`
1. Verify that the nvidia runtime has been found by k3s: `sudo grep nvidia /var/lib/rancher/k3s/agent/etc/containerd/config.toml`

You may need to do this, I lost bout 8 hours of my life just trying to get this to work (is is worth it to get access to a 4090 in my k8s cluster? Maybe...)
```
Set-NetFirewallHyperVVMSetting -Name '{40E0AC32-46A5-438A-A0B2-2B479E8F2E90}' -DefaultInboundAction Allow
New-NetFirewallHyperVRule -Name VXLAN -DisplayName "VXLAN Fix" -Direction Inbound -VMCreatorId '{40E0AC32-46A5-438A-A0B2-2B479E8F2E90}' -Protocol UDP -LocalPorts 8472
```


## Renovate WIP
Currently testing renovate to keep things updated. 

Prerequisite step:
Create an access token here https://github.com/settings/personal-access-tokens With these permissions https://docs.renovatebot.com/modules/platform/github/

Run with:
```
docker run --rm -e RENOVATE_REPOSITORIES=ryanbeales/personal-microk8s-config -e RENOVATE_PLATFORM=github -e RENOVATE_REPORT_TYPE=logging -e RENOVATE_TOKEN={TOKEN GOES HERE} renovate/renovate --dry-run=full
```

Eventually I can move this to run within the cluster or in github actions.