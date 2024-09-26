# Lesson 11 Lab: Using ConfigMaps and Secrets

1. Create index.html file that has "hello world"
2. Create ConfigMap with the contents of the index.html file
3. Create secret with MYPASSWORD=verysecret
4. Create a Manifest file that starts an nginx deployment that mounts the index.html file from the ConfigMap on /usr/share/nginx/html, and sets the env variable from the secret

## My Solution

```yaml
vim index.html
# Add 'hello world' to index.html
kubectl create configmap cm-lesson11 --from-file=index.html
kubectl create secret generic secret-lesson11 --from-literal=MYPASSWORD=verysecret
 k create deployment deployment-lesson11 --image=nginx --dry-run=client -o yaml > d-lesson11
vim d-lesson11
# Get ConfigMap and Secret templates from kubernetes.io and add to deployment
```


## Instructor's Solution
