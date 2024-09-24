# Lesson 8 Demos

## Creating Services

```yaml
k create deployment nginxsvc --image=nginx
k scale deployment nginxsvc --replicas=3
k expose deployment nginxsvc --port=80
k describe svc nginxsvc # look for endpoints
k get svc nginx -o=yaml
k get svc
k get endpoints
```

## Accessing Applications Using Services

```yaml
# Continued from above
minikube ssh
curl https://svc-ip-address
exit
k edit svc nginxsvc
  ...
  protocol: TCP
  nodePort: 32000
type:NodePort
k get svc

# From host
curl http://$(minikube ip):32000
```

## Using NetworkPolicy

```yaml
k apply -f nwpolicy-complete-example.yaml
k expose pod nginx --port=80
# Next command should fail
k exec -it busybox -- wget --spider --timeout=1 nginx
k label pod busybox access=true
# Now it will work
k exec -it busybox -- wget --spider --timeout=1 nginx
```
