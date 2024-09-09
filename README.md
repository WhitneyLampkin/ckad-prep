# Certified Kubernetes Application Developer (CKAD) Exam Prep
Quick notes and cheat sheets to prep for the CKAD certification exam.


## Quick Environment Setup
```shell
# set alias for kubectl
alias k=kubectl

# set environment variable for kubectl dry run and output options. Use $do in your kubectl command instead
export do="--dry-run=client -o yaml"

# use kn ns-name to switch namespace quickly
alias kn="kubectl config set-context --current -namespace "
```

```shell
## Namespace
kubectl create ns ns-name


## Pod
kubectl run pod-name --image busybox --dry-run=client --command sleep 3600 --labels tier=backend --dry-run=client -o yaml > pod.yml
# get into container with shell interface
kubectl exec -it pod-name -- sh
# output logs, i.e capturing log lines has error keyword
kubectl logs pod-name container-name | grep -i error > /opt/errors.txt


## Deployment
kubectl create deploy nginx-deploy --image nginx:1.16 --replicas 4 --dry-run=client -o yaml > deploy.yml
# scale deployment
kubectl scale deploy nginx-deploy --replicas 1
kubectl scale deploy nginx-deploy --replicas 6
# rollout/update deployment
kubectl set image deploy/nignx-deploy nginx=nignx:1.17
# show deployment rollout status
kubectl rollout status deploy/nginx-deploy
# show deployment rollout history
kubectl rollout history deploy/nginx-deploy
kubectl rollout history deploy/nginx-deploy --revision=1
# undo deployment rollout
kubectl rollout undo deploy/nginx-deploy


## Service Account
kubectl create sa sa-name


## Secret/Config Map
kubectl create cm cm-name --from-literal SLEEP_TIME=10 --from-literal CODE_TIME=5
kubectl create secret generic secret-name --from-literal DB_Host=sql01 --from-literal DB_User=root --from-literal DB_Password=easy123


## Node
kubectl label nodes node01 node_type=alpha
kubectl taint nodes node01 node_type=alpha:NoSchedule


## Job/Cronjob
kubectl create job job-name --image busybox:1.31.0 -- sleep 10 && echo done --dry-run=client -o yaml > job.yml
kubectl create cronjob cronjob-name -schedule "*/1 * * * *" --image busybox --dry-run=client -o yaml > cronjob.yml


## Serivce
# create a node port service by exposing a deployment
# 1. use the command below
# 2. edit the YAML by adding the nodePort https://kubernetes.io/docs/concepts/services-networking/service/#nodeport
kubectl expose deployment nginx-deploy --name nginx-service --port 8080 --target-port 8080 --type NodePort --dry-run=client -o yaml > svc.yml
# use kubectl get ep to troubleshoot service, if the service has no endpoint, then the service is not working
kubectl get ep


## Ingress resource
kubectl create ingress my-video-service-ingress --rule "mock-domain.com/video=video-service:8080"
```
