# Lesson 9 Demos

## Running the Minikube Ingress Addon

```yaml
# Note: Creating Ingress controllers will NOT be on the CKAD exam.
minikube addons list
minikube addons enable ingress
k get ns
k get pods -n ingress-nginx
```
