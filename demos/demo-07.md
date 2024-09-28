# Lesson 7 Demos

## Managing Scalability

```yaml
k create -f redis-deploy.yaml # errors on api version
k api-versions
# Edit redis-deploy.yaml and change apiVersion to apps/v2
k create -f redis-deploy.yaml
k edit deploy redis # change number of replicas
k get all
k delete rs redis-xxx
```

## Applying Application Updates

```yaml
k create deploy nginxup --image=nginx:1.14
k get all --selector app=nginxup
k set image deploy nginx nginx=nginx:1.17
k get all --selector app=nginxup
```

## Investigating Current Settings

```yaml
# Create bluelabel deployment
k get deploy bluelabel -o yaml
k edit deploy bluelabel # set maxUnavailable:2 and maxSurge:4
k scale deploy bluelabel --replicas=4
k set env deploy bluelabel type=blended
k get all --selector app=bluelabel
```

## Managing Rollout History

```yaml
k create -f rolling.yaml
k rollout history deployment
k edit deployment rolling-nginx # change version to 1.15
k rollout history deployment
k describe deployments rolling-nginx
k rollout history deployment rolling-nginx --revision=2
k rollout history deployment rolling-nginx --revision=1
k rollout undo deployment rolling-nginx --to-revision=1
```

## Setting up Autoscaling (OPTIONAL - NOT ON EXAM)

```yaml
# Resources: https://github.com/sandervanvugt/ckad
cd ckad/autoscaling
docker build -t php-apache .
# Using the image from teh Dockerfile as provided by the image registry
k apply -f hpa.yaml
k autoscale deployment php-apache --cpu-percent=50 --min=1 --max=10
k get hpa

# Switch to another terminal
k run -it load-generator --rm --image=busybox --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://php-apache;done"

# Back to original terminal
minikube addons enable metrics-server
k get hpa
k get deploy php-apache
k delete pod load-generator
k get hpa
k get deploy php-apache
```
