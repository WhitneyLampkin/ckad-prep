# Random CKAD Notes

## My Most Annoying Concepts
**Using Commands**
- Docker: `ENTRYPOINT` --> K8S: `command`
- Docker: `CMD` --> K8S: `args`
- Mental Model
  - Do I need shell features (&&, |, etc.)?
    - Yes: Use `sh -c`
    - No: Use `--`
   
## Service Account + Secret Flow
- Service Account (identity) + Token (credential) + Secret (storage for the credential)
  1. Create SA: `kubectl create sa my-sa` - provides identity but not credentials to do anything yet.
  2. Create Secret w/ proper annotation (below) - K8s will detect that the secret is for the SA and generate a JWT token that is stored in `.data.token (base64 encoded)`
     ```yaml
     kubectl create sa neptune-sa-v2 -n neptune
     kubectl apply -f - <<EOF
     apiVersion: v1
     kind: Secret
     metadata:
       name: neptune-sa-v2-token
       namespace: neptune
       annotations:
         kubernetes.io/service-account.name: neptune-sa-v2
     type: kubernetes.io/service-account-token
     EOF
     ```
- `kubectl get secret my-sa-token -o jsonpath='{.data.token}' | base64 -d` - get decoded value of token
- Use `serviceaccount` with in pod
   ```yaml
    spec:
    serviceAccountName: my-sa
    ```
- K8s automatically injects into containers at `/var/run/secrets/kubernetes.io/serviceaccount/token`
- `ServiceAccount` is the identity, but `RoleBinding` describes what it can do:
  ```yaml
  kind: RoleBinding
  subjects:
  - kind: ServiceAccount
    name: my-sa
  ```
- SAs are used with pods, deployments, jobs and cronjobs...

## Readiness Probe that executes a command:
```yaml
readinessProbe: # add
  exec: # add
    command: # add
    - sh # add
    - -c # add
    - cat /tmp/ready # add
  initialDelaySeconds: 5 # add
  periodSeconds: 10 # add
```

## Creating Services
`k run <pod_name> ...` - create a pod or deployment, etc.
`k expose <pod or deployment> --type=ClusterIP(default) ...` - expose pod, deployments, etc with new service

## Other Notes
`> [file_name]` - output to file
`k describe pod [pod_name] | grep -i status:` - output the current status of a pod
`k describe job` - see job history in Events section 
