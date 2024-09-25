# Lesson 11 Demos: Managing ConfigMaps and Secrets

## Generating a YAML File with Variables

```yaml
k create deploy [DEPLOYMENT_NAME] --image=mariadb
k describe pods [POD_NAME]
k logs [POD_NAME]
k set env deploy [DEPLOYMENT_NAME] MYSQL_ROOT_PASSWORD=password
k get deploy [DEPLOYMENT_NAME] -o yaml > [ENTER_NEW_FILE_NAME]
```
