# Advanced CKAD Practice Exam - 2026-06-30

**Duration:** 2 hours  
**Total Points:** 160  
**Difficulty:** Hard (Realistic exam-level)  
**Namespace:** Primarily `production` and `staging`

## Instructions

1. Apply setup-resources.yaml to initialize the exam environment
2. No hand-holding—read requirements carefully and determine implementation details
3. You may reference `kubectl explain` and inline documentation
4. All resources must be declarative (YAML) in their final form
5. Some tasks have interdependencies—read all tasks before starting

## Setup

```bash
kubectl apply -f setup-resources.yaml
```

---

## Tasks

### 1) Graceful Shutdown with Termination Grace Period (12 points)

The `api-server` deployment needs to handle graceful shutdown. Clients may have in-flight requests during pod termination.

1. Update the `api-server` deployment to give containers 30 seconds to gracefully shut down before being force-killed
2. Add a preStop hook that waits 5 seconds before signaling shutdown
3. Verify the configuration without redeploying

Success criteria:
- Deployment spec includes terminationGracePeriodSeconds: 30
- preStop lifecycle hook is configured correctly
- Pod gracefully exits within timeout window

---

### 2) Multi-Container Pod with Init Container (14 points)

Create a pod in namespace `production` named `worker` that:
1. Uses an init container to download and extract configuration from a ConfigMap
2. Main container runs `busybox:1.36` and sleeps for 3600s
3. Init container must populate a shared volume with data from ConfigMap `app-config`
4. Main container mounts the shared volume at `/config` and logs the contents every 30s

Success criteria:
- Init container completes before main container starts
- Shared volume contains ConfigMap data
- Main container can read the configuration

---

### 3) Sidecar Logging Container (14 points)

Add a sidecar container to the `api-server` deployment that:
1. Runs `busybox:1.36` and tails logs from a shared volume (written by main container to /var/logs)
2. The sidecar mounts the same volume and continuously reads logs
3. Main container must write logs to `/var/logs/app.log` via stdout redirection
4. Do not modify the main container command; achieve logging via volume sharing

Success criteria:
- Deployment has 2 containers per pod
- Logs are written to shared volume
- Sidecar can read them

---

### 4) Liveness & Readiness Probes with Custom Endpoints (12 points)

The `api-server` deployment has a basic liveness probe but needs refinement:

1. Update the deployment to add a readiness probe on `/ready` endpoint (port 3000)
2. Set liveness probe to `/health` with initialDelaySeconds=15, periodSeconds=10
3. Set readiness probe with initialDelaySeconds=5, periodSeconds=5, failureThreshold=3
4. Both probes should timeout after 2 seconds

Success criteria:
- Both probes configured correctly
- Readiness excludes pod from endpoints until ready
- Liveness restarts unhealthy pods

---

### 5) Fix the Broken Pod (11 points)

Pod `broken-app` in namespace `production` is not running. Diagnose and fix it:

1. Identify why the pod is failing to start
2. Fix the pod by modifying only the necessary fields
3. Pod must remain named `broken-app`
4. After fix, pod should enter Running state

Success criteria:
- Pod status changes to Running
- Pod stays Running for at least 60 seconds
- You understand why it was broken

---

### 6) ConfigMap as Volume with Auto-Reload (13 points)

Create a deployment in namespace `production` called `config-watcher` that:

1. Mounts the ConfigMap `nginx-config` as a volume at `/etc/nginx/conf.d`
2. Runs an nginx container that uses this config
3. Configure nginx to reload config when updated (without pod restart)
4. The container should log when config is loaded

Success criteria:
- ConfigMap is mounted as a volume
- Nginx serves requests using the mounted config
- Changes to ConfigMap eventually reflected without pod restart (within 1 min)

---

### 7) StatefulSet with Persistent Storage (14 points)

The `database` StatefulSet exists but is incomplete. Fix it:

1. Add a persistent volume claim template (pvct) so each pod gets its own PVC
2. Name the volumeClaimTemplate `data-volume`
3. Request 2Gi storage with ReadWriteOnce access mode
4. Mount it at `/data` in the container
5. Pod hostname should resolve via DNS service discovery

Success criteria:
- StatefulSet has 1 replica with stable pod name (database-0)
- PVC is created and bound
- Pod hostname is `database-0.database.production.svc.cluster.local`

---

### 8) Cross-Namespace Service Discovery (13 points)

Create a service in namespace `staging` that allows pods there to reach `api-server-svc` in namespace `production`:

1. No actual network connection required, just proper service DNS setup
2. Create a service in `staging` that acts as a reference to the production service
3. Pods in `staging` should be able to reach `api-server` via stable DNS

Success criteria:
- Service exists in `staging` namespace
- DNS name resolves from staging pods
- Traffic can be routed across namespaces

---

### 9) RBAC: Restrict Access Across Namespaces (14 points)

You have `app-deployer` ServiceAccount in `production`. Extend RBAC so:

1. `app-deployer` can create and delete deployments only in `production`
2. `app-deployer` can view (get, list) pods in both `production` and `staging`
3. Create a ClusterRole for viewing pods across namespaces
4. Do not allow `app-deployer` to delete anything

Success criteria:
- ServiceAccount has correct role bindings
- Permissions follow least privilege
- Cross-namespace read access works
- Delete operations fail

---

### 10) Resource Requests & Limits Under Load (12 points)

Update the `api-server` deployment to handle autoscaling:

1. Set CPU request to 50m, limit to 200m
2. Set memory request to 128Mi, limit to 256Mi
3. Verify that pods with these limits don't get evicted under normal load
4. Document what would happen if limit is exceeded

Success criteria:
- Resource requests/limits are properly set
- Pods remain in Running state
- You understand eviction scenarios

---

### 11) NetworkPolicy: Restrict Egress (13 points)

Create a NetworkPolicy in namespace `production` that:

1. Denies all egress traffic from pods by default
2. Allows egress only to DNS (port 53, UDP)
3. Allows egress to api-server pods (port 3000)
4. Policy should be named `api-egress-policy`

Success criteria:
- Policy denies egress by default
- Specific egress rules are defined
- Pods can still reach DNS and internal services

---

### 12) Helm Basics: Chart Creation (15 points)

Create a simple Helm chart in a directory called `my-app-chart`:

1. Create a chart that deploys a simple nginx pod
2. Make container port configurable via values.yaml (default 80)
3. Make image tag configurable (default 1.25)
4. Create a Service that exposes the pod
5. Generate a template and ensure it renders correctly

Success criteria:
- Chart has valid structure (Chart.yaml, values.yaml, templates/)
- `helm template my-app-chart` renders valid YAML
- Values are correctly substituted
- `helm install` would work (don't actually install)

---

### 13) Pod Affinity & Anti-Affinity (13 points)

Update the `api-server` deployment to:

1. Add pod anti-affinity so no two `api-server` pods run on the same node (unless required)
2. Add pod affinity so pods preferably run on nodes labeled `tier=backend`
3. Use "preferred" (soft) affinity, not "required"

Success criteria:
- Deployment has affinity rules
- Pods spread across nodes
- Rules enforce no two replicas on same node

---

### 14) CronJob with Failure Handling (13 points)

The `backup-job` CronJob exists but is incomplete:

1. Add a retry mechanism: fail 3 times before marking job as failed
2. Set backoffLimit to 2
3. Set activeDeadlineSeconds to 300 (5 minutes max runtime)
4. Ensure job logs are retained for debugging

Success criteria:
- CronJob runs on schedule
- Failed attempts trigger retries
- Jobs complete or timeout correctly

---

### 15) Debugging Pod Eviction (12 points)

A pod in namespace `production` is being evicted repeatedly:

1. Create a test pod that consumes more memory than its limit (intentionally)
2. Observe the eviction behavior
3. Identify the eviction reason (check pod status, events)
4. Fix the pod by increasing memory limit or decreasing consumption

Success criteria:
- You observe OOMKilled or Evicted status
- You understand why eviction occurred
- You fix it successfully

---

### 16) Service Mesh Concepts: Traffic Split (14 points)

Create two versions of a simple service in namespace `production`:

1. Create deployment `api-server-v1` running nginx:1.25
2. Create deployment `api-server-v2` running nginx:1.26
3. Create a service that can route to both (using selectors or manual endpoints)
4. Configure traffic to split 80% to v1, 20% to v2

Success criteria:
- Both deployments are running
- Service can route to both versions
- Traffic split is configurable

---

### 17) Container Registry Authentication (11 points)

Configure the `production` namespace to pull images from a private registry:

1. Use the existing `registry-secret` in namespace `production`
2. Update the `api-server` deployment to use imagePullSecrets
3. No actual private registry needed—just verify configuration

Success criteria:
- Secret exists and is referenced in deployments
- Deployment spec includes imagePullSecrets
- Pod spec would authenticate to registry

---

## Validation Commands

```bash
# Check deployments
kubectl get deployments -n production

# Check pods and their status
kubectl get pods -n production -o wide

# Check RBAC
kubectl auth can-i create deployments --as=system:serviceaccount:production:app-deployer -n production

# Check network policies
kubectl get networkpolicies -n production

# Check Helm chart
helm template my-app-chart

# Check StatefulSet
kubectl get statefulsets -n production

# Check CronJob
kubectl get cronjobs -n production

# Check events
kubectl get events -n production --sort-by='.lastTimestamp'
```

---

## Cleanup

```bash
kubectl delete namespace production staging logging
```

---

## Scoring Guide

- **150-160 points (94-100%):** A+ — Excellent. Ready for real exam.
- **130-149 points (81-93%):** A — Very good. Minor gaps.
- **110-129 points (69-80%):** B — Good fundamentals. Needs practice on advanced topics.
- **90-109 points (56-68%):** C — Passing. Significant gaps remain.
- **Below 90 (< 56%):** D — Needs more prep.

**Time target:** Complete in 90 minutes (leaving 30 min buffer)
