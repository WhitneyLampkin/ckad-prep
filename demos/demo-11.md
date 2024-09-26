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
