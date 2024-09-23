# Lesson 6 Lab: Managing Pod Advanced Features

Create a manifest file that defines the secret-app application (pod; not a deployment), which should meet the following requirements:

1. Runs in the namespace secret
   `k create ns secret`
3. Uses busybox image to run the command sleep 3600
   `k run secret-app --image=busybox -o yaml -- sleep 3600 > secretapp.yaml`
5. Restart only if it fails
   `vim secretapp.yaml` - update restartPolicy
7. Memory request 64 MiB, upper threshold of 128 MiB
   `vim secretapp.yaml` - get resources yaml from k8s documentation to paste in yaml file and update requests and limits

## Instructor's Solution

```yaml
k create ns secret --dry-run=client -o yaml > lesson6lab.yaml
k run secret-app --image=busybox -n secret --dry-run=client -o yaml -- sleep 3600 >> lesson6lab.yaml
# Restart Policy - search in pod.spec for the policy
k explain pod.spec | less
vim lesson6lab.yaml
# Update restartPolicy to OnFailure
# Copy resource yaml from k8s docs
```
