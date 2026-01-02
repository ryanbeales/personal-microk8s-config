# KRO Templates

This directory contains `ResourceGraphDefinitions` (templates) for use with the [KRO (Kubernetes Resource Operator)](https://kro.run).

## SimpleApp

The `SimpleApp` template provides a high-level abstraction for deploying a standard containerized application. It automatically creates:
- A **Deployment** with the specified image and port.
- A **Service** to expose the application within the cluster.
- An **HTTPRoute** to expose the application externally via the cluster's Gateways (`crobasaurusrex-gateway` and `crobceratops-gateway`).

### Usage Example

To use the `SimpleApp` template, create a manifest like the following:

```yaml
apiVersion: v1alpha1
kind: SimpleApp
metadata:
  name: my-cool-app
  namespace: default
spec:
  image: nginx:latest
  port: 80
  hostnames:
    - "my-app.example.com"
```

### Schema Details

| Field | Type | Description | Default |
|-------|------|-------------|---------|
| `image` | `string` | The container image to run. | (Required) |
| `port` | `integer` | The port the application listens on. | `80` |
| `hostnames` | `[]string` | A list of hostnames for the HTTPRoute. | (Required) |
