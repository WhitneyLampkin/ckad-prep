# Exam Notes
Final notes from exam prep.

## Pod

```yaml
# Use -rm to create a temp pod, which will be removed after running
kubectl run busybox --rm --image=busybox -it  ...
# Example
kubectl run busybox --rm --image=busybox -it --restart=Never --wget -O- [PUT THE POD'S IP ADDRESS HERE]:80

# k create deploy will automaticlaly set app label to name of deployment but to overwrite use
kubectl label deployment foo --overwrite app=foo
```

## Networking & Services

```yaml
# Creating Services
k expose deploy ...
k create svc ...
k edit deploy ...

# Get endpoints
k describe svc ...
k get endpoints

# Create pod and expose port, which creates a Pod and Service
kubectl run nginx --image=nginx --restart=Never --port=80 --expose
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

## Observability

```yaml
# Check and verify liveness probe
kubectl describe pod [POD_NAME] | grep -i liveness # ...or readiness, etc.

# Create pod and execute command within container
kubectl run busybox --image=busybox --restart=Never -- /bin/sh -c 'i=0; while true; do echo "$i: $(date)"; i=$((i+1)); sleep 1; done'
kubectl logs busybox -f # follow the logs

# Get CPU/memory utilization for nodes
k top nodes
```
## Advanced Pod Features

```yaml
# Taints allows nodes to repel a set of pods
k taint nodes ...
# Tolerations are added to pods to allow the scheduler to preferrably add them to the node with specific taint.
tolerations:
- key: "key1"
  operator: "Equal"
  value: "value1"
  effect: "NoSchedule"
```

## State Persistence

```yaml
# To connect to a specific container in a multicontainer pod
k exec -it [POD] -c [CONTAINER] -- /bin/sh

# Copy a pod file to local directory
kubectl cp [POD]:/etc/passwd ./passwd # kubectl cp command
```
