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

## Creating Custom Images (skipped)

## Using Sidecars (skipped)

## Fixing a Deployment

### My Solution
```yaml
k apply -f redis.yaml
# Error because resource wasn't found in defined api version; changed from v1beta1 to v1
k api-resources
k apply -f redis.yaml
k run nginx --image=nginx -o yaml --dry-run=client --port=80 -n ckad-ns3 > nginx.yaml
vim nginx.yaml
# Add template code for probe from docs
k create ns ckad-ns3
k apply -f nginx.yaml
```

### Instructor's Solution
```yaml

```

## Creating a Deployment

### My Solution
```yaml
kubectl create deployment nging --image=nginx:1.18 --replicas=5 -o yaml --dry-run=client > nginx-exam.yaml
vi nginx-exam.yaml

# Update deployment manifest
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: nginx
    service: nginx
  name: nginx
spec:
  replicas: 5
  selector:
    matchLabels:
      app: nginx
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: nginx
        type: webshop
    spec:
      containers:
      - image: nginx:1.18
        name: nginx
        resources: {}
  strategy:
   type: RollingUpdate
   rollingUpdate:
     maxSurge: 8 
     maxUnavailable: 5

# Create deployment
k apply -f nginx-exam.yaml

# Update deployment image to latest
kubectl set image deployment/nginx nginx=nginx:latest

# Verify
k describe deploy nginx | grep -i image
```

### Instructor's Solution
```yaml

```











































