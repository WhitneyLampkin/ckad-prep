# Lesson 9 Demos

## Running the Minikube Ingress Addon

```yaml
# Note: Creating Ingress controllers will NOT be on the CKAD exam.
minikube addons list
minikube addons enable ingress
k get ns
k get pods -n ingress-nginx
```

## Creating Ingress
> _NOTE: Continued from Lesson 8.4_

```yaml
k get deployment
k get svc nginxsvc
curl http://$(minikube ip):32000
k create ingress nginxsvc-ingress --rule="/=nginxsvc:80" --rule="/hello=newdep:8080"
sudo vim /etc/hosts
$(minikube ip) nginxsvc.info
k get ingress # wait until the ip address is shown
curl nginxsvc.info
```
