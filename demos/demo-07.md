# Lesson 7 Demos

## Managing Scalability

```yaml
k create -f redis-deploy.yaml
k get api-versions
# Edit redis-deploy.yaml and change apiVErsion to apps/v2
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

