# CKAD Kubernetes Concepts – Muscle Memory Playbook

This guide is designed to commit Kubernetes application‑level concepts to muscle memory for the CKAD (Certified Kubernetes Application Developer) exam. CKAD is not a theory exam — it is a speed‑constrained, hands‑on execution test. Reading alone will not pass it. Reflexive command execution and YAML recall will.

This document is structured to build procedural memory, pattern recognition, and situational fluency — the exact skills CKAD rewards.

## CKAD Reality Check

- 100% hands‑on, terminal‑only
- Open book, but docs lookup time is lethal
- Focused on application developer responsibilities, not cluster administration
- No kubeadm, no etcd, no scheduler internals
- You pass CKAD by executing quickly and correctly — not by knowing trivia.

## Core Domains CKAD Emphasizes

You should assume most tasks will involve:

- Pods
- Deployments / ReplicaSets
- Jobs & CronJobs
- ConfigMaps & Secrets
- Services (primarily ClusterIP, basic networking)
- Probes (liveness, readiness, startup)
- Logs, exec, describe (observability)
- Volumes & PVCs (basic persistence)
- SecurityContext / ServiceAccounts (light RBAC usage)
- Namespaces

## Memory System #1: Command‑First Muscle Memory

High‑scoring candidates don't "think" about commands — they type them reflexively.

### Commands You Must Burn Into Muscle Memory

- `kubectl run`
- `kubectl create deployment`
- `kubectl expose`
- `kubectl scale`
- `kubectl set env`
- `kubectl get -o yaml`
- `kubectl describe`
- `kubectl logs`
- `kubectl exec`
- `kubectl apply`
- `kubectl delete`
- `kubectl edit`
- `kubectl explain`

### Example Drill (No Docs Allowed)

**Goal:** Complete all steps in under 2 minutes.

```bash
kubectl run web --image=nginx --restart=Never --dry-run=client -o yaml > pod.yaml
kubectl apply -f pod.yaml
kubectl logs web
kubectl exec -it web -- /bin/sh
kubectl delete pod web
```

**Repeat until typing is automatic.**

✅ **CKAD rewards command fluency, not creativity.**

## Memory System #2: YAML Pattern Recognition (Skeleton Recall)

You should be able to type core YAML structures from memory without copying.

### Pod YAML Skeleton (From Memory)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: example-pod
spec:
  containers:
  - name: app
    image: nginx
    ports:
    - containerPort: 80
```

### Deployment YAML Skeleton

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: example-deploy
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: app
        image: nginx
        ports:
        - containerPort: 80
```

### Service YAML Skeleton

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-svc
spec:
  selector:
    app: web
  ports:
  - port: 80
    targetPort: 80
```

✅ **CKAD tests structure recall, not YAML originality.**

## Memory System #3: Configuration Injection Patterns

### ConfigMap via Environment Variables

```bash
kubectl create configmap app-config --from-literal=ENV=prod
```

```yaml
env:
- name: ENV
  valueFrom:
    configMapKeyRef:
      name: app-config
      key: ENV
```

### ConfigMap via Volume

```yaml
volumes:
- name: config
  configMap:
    name: app-config
```

```yaml
volumeMounts:
- name: config
  mountPath: /etc/config
```

### Secret Patterns

```bash
kubectl create secret generic db-secret --from-literal=PASSWORD=pass
```

```yaml
envFrom:
- secretRef:
    name: db-secret
```

## Memory System #4: Observability Reflexes

You should instinctively reach for:

```bash
kubectl describe pod <name>
kubectl logs <pod>
kubectl logs <pod> -c <container>
kubectl exec -it <pod> -- /bin/sh
```

### Probes (Common CKAD Task)

```yaml
livenessProbe:
  httpGet:
    path: /health
    port: 80
  initialDelaySeconds: 10
  periodSeconds: 5
```

**Understand where probes live (inside container spec).**


Memory System #5: Constraint‑Based Scenarios
CKAD questions almost always include constraints:

Must not delete existing resources
Must work in a specific namespace
Must modify only a single field
Must not break running workloads
Constraint Drill Example


Modify an existing Deployment to add an environment variable without recreating it.


kubectl edit deployment web


or
kubectl patch deployment web \
  -p '{"spec":{"template":{"spec":{"containers":[{"name":"app","env":[{"name":"MODE","value":"prod"}]}]}}}}'


Practicing these constraints locks in real exam conditions.


Namespaces (Critical but Under‑Practiced)

Many failures occur simply due to wrong namespace.

```bash
kubectl get pods -n dev
kubectl config set-context --current --namespace=dev
```

✅ **Always confirm namespace before operating.**

## Mental Indexing of Kubernetes Docs

Do NOT memorize everything — memorize where things live.

- Probes → Workloads → Pods → Probes
- Volumes → Storage → Volumes
- SecurityContext → Pods → Security Context

Your first instinct should be:

```bash
kubectl explain pod.spec.containers.livenessProbe
```

**Only open docs if needed.**

## Common CKAD Traps to Avoid

- Watching videos without terminal practice
- Copy‑pasting YAML instead of typing
- Practicing only "happy paths"
- Ignoring namespaces
- Over‑studying admin topics (etcd, scheduler)

## Recommended Practice Loop (Repeatable)

1. Concept skim (5–10 min)
2. Command drill (no docs)
3. YAML skeleton typing
4. Constraint modification task
5. Delete everything
6. Repeat without references

**Speed + accuracy compound quickly.**

## CKAD Mindset

Treat CKAD like an incident response simulation:

- Observe fast
- Act surgically
- Validate constantly
- Don't panic

✅ **CKAD rewards calm, fluent executors — not Kubernetes philosophers.**

## CKAD‑Style Practice Scenarios (No Solutions)

Below are exam‑style tasks modeled after real CKAD questions. Each scenario includes explicit constraints. Do not solve them immediately — read, plan, then execute.

⏱ **Recommended timing: 5–8 minutes per scenario**

### Scenario 1: Pod Creation with Environment Variables

**Task:** Create a Pod named `env-pod` using the `busybox` image.

**Constraints:**
- Must run in namespace `dev`
- Must define an environment variable `MODE=prod`
- Pod must run the command `sleep 3600`
- Do not use imperative `kubectl run` without `--dry-run`

### Scenario 2: Deployment Scaling Under Constraint

**Task:** Update an existing Deployment named `web-app`.

**Constraints:**
- Scale replicas to 4
- Must not recreate or delete the Deployment
- Must not modify labels or container image

### Scenario 3: Service Exposure

**Task:** Expose an existing Deployment `api` via a Service.

**Constraints:**
- Service name must be `api-svc`
- Use ClusterIP
- Service must expose port 8080 to container port 80
- Do not edit Deployment YAML

### Scenario 4: ConfigMap Injection (envFrom)

**Task:** Inject configuration into an existing Pod `config-pod`.

**Constraints:**
- ConfigMap name: `app-settings`
- Must inject all keys as environment variables
- Must not delete or recreate the Pod

### Scenario 5: ConfigMap as Volume

**Task:** Mount a ConfigMap into a Pod.

**Constraints:**
- Pod name: `volume-pod`
- ConfigMap name: `file-config`
- Mount path: `/etc/config`
- Read‑only mount

### Scenario 6: Secret Consumption

**Task:** Consume an existing Secret `db-secret`.

**Constraints:**
- Must expose key `PASSWORD` as env var `DB_PASSWORD`
- Pod name: `secret-pod`
- Do not hardcode secret values

### Scenario 7: Liveness Probe Addition

**Task:** Add a liveness probe to an existing container.

**Constraints:**
- Deployment name: `health-app`
- HTTP GET probe on `/healthz` port 8080
- Initial delay: 15s
- Period: 10s
- Do not change readiness probes

### Scenario 8: Troubleshooting via Logs

**Task:** Identify why Pod `crash-pod` keeps restarting.

**Constraints:**
- Do not modify Pod spec
- Use logs and describe only
- Identify failing container if multiple exist

### Scenario 9: Exec‑Based Validation

**Task:** Validate file existence inside a running container.

**Constraints:**
- Pod name: `inspect-pod`
- File path: `/data/config.yaml`
- Must not copy files out of the Pod

### Scenario 10: Namespace Isolation

**Task:** Create resources in the correct namespace.

**Constraints:**
- Namespace: `testing`
- All resources must be created in `testing`
- Must not specify namespace flag repeatedly (optimize workflow)

### Scenario 11: Job Creation

**Task:** Create a Job that runs once.

**Constraints:**
- Job name: `one-shot`
- Image: `busybox`
- Command: `echo CKAD`
- Job must complete successfully

### Scenario 12: CronJob Definition

**Task:** Define a CronJob.

**Constraints:**
- Name: `heartbeat`
- Schedule: every 5 minutes
- Image: `busybox`
- Command: `date`
- Do not run immediately

### Scenario 13: Resource Limits

**Task:** Add resource constraints to an existing Pod.

**Constraints:**
- Pod name: `limited-pod`
- CPU request: 100m
- CPU limit: 200m
- Memory request: 64Mi
- Memory limit: 128Mi

### Scenario 14: ServiceAccount Usage

**Task:** Run a Pod using a specific ServiceAccount.

**Constraints:**
- Pod name: `sa-pod`
- ServiceAccount: `app-sa`
- Do not create new ServiceAccounts

### Scenario 15: Field‑Level Modification Only

**Task:** Modify an existing Deployment.

**Constraints:**
- Change container image to `nginx:1.25`
- Must not modify any other fields
- Use the smallest possible change

---

✅ **These scenarios intentionally mirror CKAD wording: clear task + sharp constraints.**

**Practice reading once, planning fast, executing clean.**
