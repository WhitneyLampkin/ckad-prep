# Lesson 10 Demos

## Using Pod Local Storage

```yaml
k explain pod.spec.volumes
cat morevolumes.yaml # provided file
k create -f morevolumes.yaml
k get pods morevol
k describe pods morevol | less  # verify there are two containers in the pod
k exec -it morevol2 -c centos1 -- touch /centos1/test
k exec -it morevol2 -c centos2 -- ls -l /centos2
```

## Defining Persistent Volumes

```yaml
cat pv.yaml # provided file
kubectl create -f pv.yaml
k get pv
k describe pv pv-volume
# Verify creation in minikube
minikube ssh
```
