# Lesson 10 Demos

## Using Pod Local Storage

```yaml
k explain pod.spec.volumes
cat morevolumes.yaml # provided file
k create -f morevolumes.yaml
k get pods morevol
k describe pods morevol | less  # verify there are two containers in the pod
k exec -it morevol -c centos1 --touch /centos1/test
k exec -it morevol -c centos2 -- ls -l /centos2
```
