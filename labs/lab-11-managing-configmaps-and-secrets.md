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

```yaml
echo hello world > index.html
k create cm lab11cm --from-file=index.html
k describe cm lab11cm
k create secret generic lab11secret --from-literal=MYPASSWORD=verysecret
k get secrets lab11secret -o yaml
k create deployment lab11deploy --image=nginx
k set env deploy lab11deploy --from=secret/lab11secret
k edit deployment.apps lab11deploy
# Get yaml from kubernetes.io to populate a volume with data stored in a ConfigMap
# Not sure why these extra steps were taken but k edit should automatically redeploy, right?
k get deploy lab11deploy -o yaml > lab11deploy.yaml
k delete deployment.apps lab11deploy
vim lab11deploy.yaml
k create -f lab11deploy.yaml
# Run and test the changes
k exec lab11deplo-XXXXXX-XXXXX -- cat /usr/share/nginx/html/index.html
k exec lab11deploy-XXXXXX-XXXXX -- env
```
