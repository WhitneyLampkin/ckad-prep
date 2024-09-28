# Lesson 13 Demos

## Installing the Helm Binary

```yaml
# Fetch the binary from github.com/helm/helm/releases - get the latest
tar xvf helm-xxx.tar.gz
sudo mv linux-amd64/helm/usr/local/bin
helm version
```

## Managing Helm Repositories

```yaml
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo list
helm search repo bitnami
# Update to ensure info is up-to-date
helm repo update
```

## Installing Helm Charts

```yaml
helm install bitnami/mysql --generate-name
k get all
helm show chart bitnami/mysql
helm show all bitnami/mysql
helm list
helm status mysql-xxxx
```

## Customizing Before Install

```yaml
helm show values bitnami/nginx
helm pull bitnami/nginx
tar xvf nginx-xxxx
vim nginx/values.yaml
helm template --debug nginx
helm install -f nginx/values.yaml my-nginx nginx/
```

> The next 4 demos are related to Canary deployments.

## Demo Step 1: Running the Old Version
```yaml
k create deploy old-nginx --image=nginx:1.14 --replicas=3 --dry-run=client -o yaml > ~/oldnginx.yaml
vim oldnginx.yaml
# Set labels (type: canary) in deployment metadata, as well as Pod metadata
k create -f oldnginx.yaml
k expose deploy old-nginx --name=oldnginx --port=80 --selectortype=canary
k get svc; k get endpoints
minikube ssh; curl <svc-ip-address> # Run this several times to see how the requests are distributed
```

## Demo Step 2: Creating a ConfigMap
```yaml
k cp <old-nginx-pod>:/usr/share/nginx/html/index.html index.html
vim index.html
  # Add a line idnentifying this as a Canary Pod to make it easier to notice.
k create cm canary --from-file=index.html
k describe cm canary
```

## Demo Step 3: Preparing the New Version
```yaml
cp oldnginx.yaml canary.yaml
vim canary.yaml
  # image: nginx:latest
  # replicas: 1
  # :%s/old/new/g
  # Mount the configMap as a volume (see Git repo canary.yaml)
k create -f canary.yaml
k get svc; k get endpoints
minikube ssh; curl <service-ip> # notice different results: this is canary in action
```

## Demo Step 4: Activating the New Version
```yaml
# Verify the names of the old and new deployment
k get deployment
# Scale canary deployment up to the desired replicas
k scale
k delete deploy # delete old deployment
```

## Creating Custom Resources
```yaml
cat crd-object.yaml
k create -f crd-object.yaml
k api-resources | grep backup
cat crd-backup.yaml
k create -f crd-backup.yaml
k get backups
```

## Installing the Calico Network Plugin
```yaml
minikube stop; minikube delete
minikube start --network-plugin=cni --extra-config=kubeadm.pod-
network-cidr=10.10.0.0/16
kubectl create -f https://docs.projectcalico.org/manifests/tigera-
operator.yaml
kubectl api-resources | grep tigera
kubecti get pods -n tigera-operator tigera-operator-xxx-yyy
wget https://docs.projectcalico.org/manifests/custom-resources.yaml
sed-i-es/192.168.0.0/10.10.0.0/g custom-resources.yaml
kubectl get installation -o yaml
kubectl get pods -n calico-system
```

## Using a StatefulSet
```yaml
cat sfs.yaml
kubectl create -f sfs.yaml
kubectl get all
kubectl get pvc
```
