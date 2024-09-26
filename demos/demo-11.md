# Lesson 11 Demos: Managing ConfigMaps and Secrets

## Generating a YAML File with Variables

```yaml
k create deploy [DEPLOYMENT_NAME] --image=mariadb
k describe pods [POD_NAME]
k logs [POD_NAME]
k set env deploy [DEPLOYMENT_NAME] MYSQL_ROOT_PASSWORD=password
k get deploy [DEPLOYMENT_NAME] -o yaml > [ENTER_NEW_FILE_NAME].yaml
```

## Generating a YAML File with Variables

```yaml
k create deploy [DEPLOYMENT_NAME] --image=mariadb
k describe pods [POD_NAME]
k logs [POD_NAME]
k set env deploy [DEPLOYMENT_NAME] MYSQL_ROOT_PASSWORD=password
k get deploy [DEPLOYMENT_NAME] -o yaml > [ENTER_NEW_FILE_NAME].yaml
```

## Providing Variables with ConfigMaps

```yaml
vim varsfile
  # Add MYSQL_ROOT_PASSWORD=password
  # Add MYSQL_USER=anna
k create cm [CM_NAME] --from-env-file=varsfile
k create deploy [DEPLOYMENT_NAME] --image=mariadb --replicas=3
k get all -selector app=mydb
k set env deploy [DEPLOYMENT_NAME] --from=configmap/[CM_NAME]
k get all --selector app=mydb
k get deploy [DEPLOYMENT_NAME] -o yaml
```

## Using ConfigMap with a Configuration File

```yaml
echo "hello world" > index.html
k create cm [CM_NAME] --from-file=index.html
k describe cm [CM_NAME]
k create deploy [DEPLOYMENT_NAME] --image=nginx
k edit deploy [DEPLOYMENT_NAME]
  # update volumes in spec.template.spec?
  # update volumeMounts in spec.template.spec.containers?
```

## Exploring Kuebrnetes Secret Use

```yaml
k get pods -n kube-system [coredns-XXX-YYY] -o yaml
  # look for ServiceAccount
k get sa -n kube-system coredns -o yaml
k get secret -n kube-system coredns-token-XXXX -o yaml
  # look at the TLS materials provided (ca.crt and token)
  # copy encoded namespace
echo [ENCODED_NS] | base64 -d
# This doesn't represent a real, secure k8s cluster.
```
