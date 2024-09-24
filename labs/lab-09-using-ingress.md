# Lesson 9 Lab: Using Ingress

## Task

1. Configure Ingress such that nginx webserver can be reached on the URL http://hostname/nginx

## My Solution
```yaml

```

## Instructor's Solution

```yaml
k create deploy lesson9lab --image=nginx
k expose deploy lesson9lab --port=80
k create ingress lesson9lab --rule="lesson9lab.example.com/=lesson9lab:80"
sudo vim /etc/hosts # include lesson9lab.example.com
# Verify
k get ingress
k edit ingress lesson9lab # change pathType to Prefix
# Test
curl http://lesson9lab.example.com # connection refused
# Investigate
k get ingress
k describe ingress lesson9lab # error - no endpoints
k get ns # no ingress ns showing means minikube ingress addon is not enabled
# Note: K8s doesn't tell you that an addon is missing
# Try curl again. If it doesn't work delete and recreate
# Verify with curl again
```
