# Practice CKAD Exam

Date: 2026-06-29  
Duration: 2 hours  
Total Points: 100

## Instructions

1. Use only kubectl and YAML manifests.
2. Use imperative commands when fast, but keep final resources declarative and valid.
3. Do not edit resources in namespaces other than those listed.
4. Unless a task says otherwise, keep existing resource names unchanged.
5. You may create temporary pods for validation.

## Setup

Apply the exam resources first:

```bash
kubectl apply -f setup-resources.yaml
```

## Allowed Namespaces

- frontend
- payments
- ckad-exam

## Tasks

### 1) Service Exposure (10 points)

In namespace frontend:

1. Create a NodePort Service named web-frontend-nodeport for deployment web-frontend.
2. Expose port 80 from the pods.
3. Set nodePort to 30080.

Success criteria:

- Service exists in frontend namespace.
- Service type is NodePort.
- nodePort is 30080.

### 2) Troubleshoot Service Routing (10 points)

In namespace payments, service payments-api-svc is misconfigured.

1. Fix the service so it correctly routes traffic to deployment payments-api.
2. Keep service name and service port unchanged.

Success criteria:

- service/payments-api-svc routes to targetPort 5678.
- Endpoints are populated.

### 3) Network Policy Access Control (10 points)

In namespace payments, ingress is currently denied.

1. Create a NetworkPolicy named allow-frontend-to-payments.
2. Allow ingress only from pods in namespace frontend with label access=allowed.
3. Allow only TCP port 5678 to pods labeled app=payments-api.

Success criteria:

- Policy exists and targets app=payments-api.
- Only specified source and port are allowed.

### 4) Rolling Update and History (10 points)

In namespace frontend:

1. Update deployment web-frontend image to nginx:1.27.
2. Record the change cause in rollout history.
3. Verify rollout completes.

Success criteria:

- Deployment image is nginx:1.27.
- Rollout history includes your update.

### 5) Config and Secret Wiring (10 points)

In namespace ckad-exam, update deployment worker.

1. Add env var APP_MODE from configmap app-config key APP_MODE.
2. Add env var DB_USER from secret db-creds key username.
3. Do not remove existing env vars or volume mounts.

Success criteria:

- Both env vars are present and sourced correctly.
- Pod template still mounts PVC shared-data at /data.

### 6) Storage Task (10 points)

In namespace ckad-exam:

1. Create pod file-writer using image busybox.
2. Mount PVC shared-data at /mnt/data.
3. Command should write "ckad-practice" to /mnt/data/result.txt and then sleep for 3600 seconds.

Success criteria:

- Pod is running.
- File write command executed successfully.

### 7) Job Creation (10 points)

In namespace ckad-exam:

1. Create a Job named db-migration.
2. Use image busybox.
3. Command should print "migration complete".
4. Job should run exactly one successful completion.

Success criteria:

- Job completes successfully.
- Completion count is 1.

### 8) CronJob Adjustment (10 points)

In namespace ckad-exam:

1. Update cronjob cleanup schedule from every 15 minutes to every 5 minutes.
2. Keep command and image unchanged.

Success criteria:

- cronjob/cleanup schedule is */5 * * * *.

### 9) Pod Troubleshooting (10 points)

In namespace ckad-exam, pod broken-shell is failing.

1. Fix the pod so it remains running.
2. Keep pod name broken-shell.
3. Use image busybox.

Success criteria:

- Pod status becomes Running.
- Container restarts stop increasing after stabilization.

### 10) RBAC (10 points)

In namespace ckad-exam:

1. Create service account deployer.
2. Create Role deployer-role allowing create, get, list on deployments in apiGroup apps.
3. Bind role to service account with RoleBinding deployer-rb.

Success criteria:

- ServiceAccount, Role, and RoleBinding exist.
- deployer has required permissions for deployments in ckad-exam.

## Suggested Validation Commands

```bash
kubectl get all -n frontend
kubectl get all -n payments
kubectl get all -n ckad-exam
kubectl get networkpolicy -n payments
kubectl get events -n ckad-exam --sort-by=.metadata.creationTimestamp
kubectl auth can-i create deployments --as=system:serviceaccount:ckad-exam:deployer -n ckad-exam
```

## Cleanup

```bash
kubectl delete ns frontend payments ckad-exam
```
