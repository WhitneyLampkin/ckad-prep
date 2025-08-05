# Lesson 14 Demos - Troubleshooting Kubernetes

## Investigating Failing Applications: busybox
```yaml
k create deploy failure1 --image=busybox
k get pods
k describe pods failure1-xxx-yyy
```

## Investigating Failing Applications: mariadbv---
```yaml
k create deploy failure2 --image=mariadb
k get pods
k describe pods failure2-xxx-yyy
k logs failure2-xxx-yyy
```

## Troubleshooting Services
```yaml
k create deploy trouble --image=nginx
k expose deploy trouble --port=80 --type=NodePort
k get endpoints
k get svc # get the NodePort
curl $(minikube ip):[NODEPORT] # enter the NodePort from above
k edit svc trouble # change the selector label
curl $(minikube up):[NODEPORT] # this should now fail
```

## Monitoring Cluster Events

| Command | Usage |
| ------- | ----- |
| `k get events` | When it's unclear which resource the issue comes from use to get an overview of cluster-wide events |
| `k get events -o wide` | Overview of cluster-wide events with details |
| `k describe ` | Get details and events for a specific resource |

## Recovering .kube/confg from Minikube
```yaml
minikube ssh
sudo -i
cp /etc/kubernetes/admin.conf/tmp
chmod 644 /tmp/admin.conf
exit; exit
scp -i $(minikube ssh-key) docker@$(minikube ip):/tmp/admin.conf~/.kube/confg
```

## Using Probes
```yaml
k create -f busybox-ready.yaml
k get pods
  # Note READY state
  # 0/1 means the pods started but isn't ready
k edit pods busybox-ready
  # Change /tmp/nothing to /etc/hosts
  # This shouldn't be allowed
k exec -it busybox-ready -- /bin/sh
  touch /tmp/nothing; exit
k get pods # the pod should start now
k create -f nginx-probes.yaml
k get pods
```
