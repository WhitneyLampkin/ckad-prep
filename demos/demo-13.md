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
