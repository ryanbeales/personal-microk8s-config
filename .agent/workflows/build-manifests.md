---
description: how to build k8s manifests using kustomize with helm support
---
1. Navigate to the directory containing the `kustomization.yaml`.
// turbo
2. Run the following command to build the manifests:
   ```
   kustomize build . --enable-helm --helm-command helm
   ```
