# Lesson 7 Lab: Managing Deployments

1. Create a YAML file that starts a deployment for nginx. It should use image version 1.9 and start 5 replicas. The deployment should have the label `type=proxy`.
2. Configure the deployment such that when it is upgraded, no more than 2 pods will be unavailable at the same time.

## My Solution

```yaml
k create deploy lab7deploy --image=nginx:1.9 --replicas=5 -o yaml --dry-run=client > lab7deploy.yaml
vim lab7deploy.yaml
k explain deploy.spec.strategy # use --recursive to see the hierarchy
# Get template yaml code from k8s docs
k create -f lab7deploy.yaml
k set image deploy/lab7deploy nginx=nginx:latest
```

## Instructor's Solution

```yaml
k create deploy lab7nginx --image=nginx:1.9 --replicas=5 -o yaml --dry-run=client > lab7deploy.yaml
vim lab7deploy.yaml
# Update deployment yaml with label and rolling update
k create -f lab7.yaml
k get all --selector app=lab7nginx
k set image deploy lab7nginx nginx=nginx:latest
k get all --selector app=lab7nginx
```

## My Result

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: lab7deploy
    type: proxy
  name: lab7deploy
spec:
  replicas: 5
  selector:
    matchLabels:
      app: lab7deploy
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: lab7deploy
    spec:
      containers:
      - image: nginx:latest
        name: nginx
        resources: {}
  strategy:
   type: RollingUpdate
   rollingUpdate:
     maxUnavailable: 2
status: {}
```

## Instructor's Result
