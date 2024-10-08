# Lesson 4

## 4.7 Running Your First Application

### Reminders
- `kubectl delete pod [POD_NAME]`
    - Deletes the pod with the provided name; the pod will not be replaced unless a deployment is being used
    - May not have the the expected results if replica sets are being used.
        - When replica sets are being used, pods are controlled by the replica sets and the replica sets are being controlled by the deployment.
        - Therefore, to delete a pod, the deployment would need to be deleted using `kubectl delete deploy [DEPLOYMENT_NAME]`.
        - If there are any related services, clean them up with `kubectl delete svc [SERVICE_NAME]`.
     
## 4.8 Setting up a Lab Environment

### Reminders
- `history` shows a list of the most recent commands ran in the terminal
