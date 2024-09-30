# Exam Notes
Final notes from exam prep.

# Networking & Services

```yaml
# Creating Services
k expose deploy ...
k create svc ...
k edit deploy ...

# Get endpoints
k describe svc ...
k get endpoints
```

- 3 types of networks
  1. Node
  2. Cluster
  3. Pod
- 4 types of services
  1. ClusterIP
  2. NodePort
  3. LoadBalancer
  4. External Name
- Service Ports
  1. TargetPort - target port to forward to on pod
  2. Port - service's assigned port
  3. NodePort - port exposed externally and accessible by users
      - only port that requires uniqueness

# Observability

```yaml
# Check and verify liveness probe
kubectl describe pod [POD_NAME] | grep -i liveness # ...or readiness, etc.
```
