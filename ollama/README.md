Run Ollama within K8s so I can use it against a GPU instance

Since the outbound connection from the host is extremely slow (different problem for a different time) I have to get on the pod and download models manually. To do so:
```
kubectl exec -it pod/{ollamapodnamehere} -n ollama -- ollama pull deepseek-coder-v2
```
Once it's saved in the model directory you won't have to do this again. 