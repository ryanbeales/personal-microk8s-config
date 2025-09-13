1. Get access key for Huggingface from https://huggingface.co/settings/tokens

1. Create secret for the access key:
```
sudo k3s kubectl create secret generic hf-token-secret --from-literal=token={secret} -n vllm
```