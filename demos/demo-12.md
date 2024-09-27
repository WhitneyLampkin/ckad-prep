# Lesson 12 Demos

## Using curl to Access API Resources

```yaml
k proxy --port=8001 &
k create deploy curginx --image=nginx --replicas=3
curl http://localhost:8001/version
# Show pods in default namespace
curl http://localhost.8001/api/v1/namespaces/default/pods
# Direct API access to a specific pod
curl http://localhost.8001/api/v1/namespaces/default/pods/curlginx/
# Deletes a pod
curl -XDELETE http://localhost:8001/api/v1/namespaces/default/pods/curlginx-xxx-yyy
```

## Dealing with Deprecation
```yaml
k create -f redis-deploy.yaml
k api-versions
k explain --recursive deploy # Can add ` | less ` at the end as well
```

## Showing Current Authorizations (RBAC)

```yaml
# RBAC provides access to API resources
# Role: access permissions
# User or ServiceAccount: entities in k8s to work with the API
# RoleBinding: connects a user or ServiceAccount to a specific Role
k auth can-i get pods
k auth can-i get pods --as [USER] # Ex. bob@example.com
```

## Using Service Accounts

```yaml
k apply -f [SA_YAML]
k apply -f list-pods.yaml
  # Alternative imperative way with kubectl
  #  kubectl create role [ROLE_NAME] --verb=list --resource=pods --dry-run=client -o yaml > list-pods.yaml
k apply -f list-pods-mysa-binding.yaml
  # Alernative imperative way with kubectl
  # kubectl create rolebinding [RB_NAME] --role=[ROLE_NAME] --serviceaccount=[SA_NAME]
k apply -f mysapod.yaml
  # Alternative way by imperatively creating a pod's yaml and manually updating with the SA info
  # kubectl run [NEW_POD_NAME] --image=[IMAGE_NAME] --dry-run=client -o yaml >> [YAML_NAME]
  # vim [YAML_NAME]
  # Get SA template from k8s.io and update yaml
# Accesssing the pod
apk add --update curl
TOKEN=$(cat/run/secrets/kubernetes.io/serviceaccount/token)
curl -H "Authorization: Bearer $TOKEN" https://kubernetes/api/v1/ --insecure
# List pods
curl -H "Authorization: Bearer $TOKEN" https://kubernetes/api/v1/namespaces/default/pods/ --insecure
```

