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

```yaml
# Continued from Lesson 8.4
k get deployment
k get svc nginxsvc
curl http://$(minikube ip):32000
k create ingress nginxsvc-ingress --rule="/=nginxsvc:80" --rule="/hello=newdep:8080"
sudo vim /etc/hosts
$(minikube ip) nginxsvc.info
k get ingress # wait until the ip address is shown
curl nginxsvc.info

# Creating deployment for the newdep service
k create deployment newdep --image-gcr.io/google-samples/hello-app:2.0
k expose deployment newdep --port=8080
# Verify
curl nginxsvc.info/hello

# --------------------------------------------------------------------------------------

# Creating Different Ingress Types

# Single service type: 1 rule that defines access to one backend Service resource
k create ingress single --rule="files=filesservice:8080"

# Simple fanout type: 2 or more rules defining different paths that refer to different services (see example above)
k create ingress single --rule="/files=filesservice:80" --rule="/db=dbservice:80"

# Name-based virtual hosting: 2 or more rules that route requests based on the host header
# Must be a DNS host for each header
k create ingress multihost --rule="my.example.com/files*=filesservice:80" --rule="my.example.org/data*=dataservice:80"
```

## Name-Based Virtual Hosting Ingress

```yaml
k create deploy mars --image-nginx
k create deploy saturn --image=httpd
k expose deploy mars --port=80
k expose deploy saturn --port=80
# Get minikube ip
minikube ip
# Add entris to /etc/hosts
sudo vim /etc/hosts
# $(minikube ip) mars.example.com
# $(minikube ip) saturn.example.com
k create ingress multihost --rule="mars.example.com/=mars:80" --rule="saturn.example.com/=saturn:80"
k edit ingress multihost # change pathType to Prefix
curl saturn.example.com
curl mars.example.com
```

# Ingress Trouble-shooting Steps

```yaml
# Get list of all ingress resources and verify the one in question is shown
k get ingress
# Look closer into the ingress resource in question
k describe ingress [INGRESS_NAME]
# If no issues, look closer into the service.
# The backend column is prefixed with the service name.
# Look closer into service and specifically check for valid Endpoints.
k get service [SERVICE_NAME]
# Get labels from previous command to find pods
k get pods --show-labels # confirm labels
# Or get pods by label, if known
k get pods -l key=value
```
