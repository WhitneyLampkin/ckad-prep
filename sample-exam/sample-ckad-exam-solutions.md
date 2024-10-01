# Sample Exam Solutions

## Working with Namespaces

### My Solution
```yaml
k create ns ckad-ns1
k run pod-a --image=httpd -n ckad-ns1
k run pod-b --image=nginx -n ckad-ns1
```

### Instructor's Solution
```yaml

```

## Using Secrets

### My Solution
```yaml
k create secret generic my-secret --from-literal=password=secret
k get secrets
k create deploy secretapp --image=nginx
k set env --from=secret/my-secret deployment/secretapp
# Verification
k exec -it secretapp-7f8f9d4f9-h557n -- sh
  # env
```

### Instructor's Solution
```yaml

```
