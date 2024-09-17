# Lab 5 - Managing Pods

1. Create a NameSpace with the name production
   - `kubectl create ns production`   
1. In the new NameSpace, run an nginx web server as a pod using the name nginx-prod
   - `kubectl run nginx-prod --image=nginx -n production`
1. Create a YAML file to make it easier to manage the reosurces just created\
   - `kubectl run nginx-prod --image=nginx -n production --dry-run=client -o yaml`
