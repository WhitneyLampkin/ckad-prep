# CKAD Memory Drills

## Volumes

Persistent storage.

### SPE(E)CH

- Secret
- PersistentVolumeClaim
- EmptyDir
- ConfigMap
- HostPath

### Secret

```yaml
volumes:
- name:
  secret:
    secretName:
```

```yaml
volumes:
- name:
  secret:
    secretName:
    items:
      key:
      path:
```

Secret path in containers:

`/var/run/secrets/kubernetes.io/serviceaccount/`

### PersistentVolumeClaim

```yaml
volumes:
- name:
  persistentVolumeClaim:
    claimName:
```

### EmptyDir

```yaml
volumes:
- name:
  emptyDir:
```

### ConfigMap

```yaml
volumes:
- name:
  configMap:
    name:
```

### HostPath

```yaml
volumes:
- name:
  hostPath:
    path:
```

## Env Vars

Configuration via environment variables.

### ACE

- All: EnvFrom/Ref/Name
- CM/Secret Key: ValueFrom/KeyRef/Name
- Env: Name/Value

### EnvFrom/Ref

```yaml
env:
- name:
  envFrom:
    configMapRef:
      name:
```

```yaml
env:
- name:
  envFrom:
    secretRef:
      name:
```

### ConfigMap/Secret KeyRef

```yaml
env:
- name:
  valueFrom:
    configMapKeyRef:
      name:
      key:
```

```yaml
env:
- name:
  valueFrom:
    secretKeyRef:
      name:
      key:
```

### Env

```yaml
env:
- name:
  value:
```

## RBAC

Role-based access control.

### SARB (RBAS)

- SA: ServiceAccount
- R: Role
- B: RoleBinding

Update pod service account name via `serviceAccountName`.

- Namespace scope: Role/RoleBinding
- Cluster scope: ClusterRole/ClusterRoleBinding

### B(A)RNS Failure Modes

- Binding missing or wrong
- Role missing resource or verb permissions
- Namespace mismatch
- ServiceAccount missing (object or pod link)

### Common Commands

```bash
kubectl create sa
kubectl create role
kubectl create rolebinding
kubectl apply -f pod.yaml
```

### Flow

ServiceAccount (linked to Pod) -> Role -> RoleBinding -> Traffic routing

### Role Rules: apiGroups

| Resource type | apiGroups |
| --- | --- |
| pods, services, configmaps | `""` |
| deployments | `apps` |
| jobs | `batch` |
| cronjobs | `batch` |
| ingresses | `networking.k8s.io` |

### Role Rules: Verbs

- get
- list
- watch
- create
- update
- patch
- delete

## Services

How traffic reaches pods.

### CLE(A)N (C -> N -> L -> E)

- ClusterIP
- NodePort
- LoadBalancer
- ExternalName

### Common Commands

```bash
kubectl create service clusterip
kubectl create service nodeport
kubectl create service loadbalancer
```

### Service Spec Template

```yaml
spec:
  type: ClusterIP | NodePort | LoadBalancer | ExternalName
  selector:
    key: value
  ports:
  - port:
    targetPort:
```

### Selectors

Services must exactly match pod labels via selectors to know which pods to expose.

### Flow

Service -> Selector -> Pod labels -> Traffic routing

### Failure Modes: L(A)TTS

- Labels for pods
- Type
- TargetPort
- Selectors

Checklist:

1. Do pods have labels?
2. Does selector match exactly?
3. Is `targetPort` correct?
4. Is service type correct?

### Mappings

| Type | Entry Point |
| --- | --- |
| ClusterIP | Virtual cluster IP |
| NodePort | `<NodeIP>:port` |
| LoadBalancer | External IP |
| ExternalName | DNS name |

## Network Policies

Pod-level traffic control (firewalls): allow or restrict traffic to pods using labels.

- Linked via `podSelector` / `matchLabels`
- Default behavior (without policy): allow all

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-something
spec:
  podSelector:
    matchLabels:
      app: backend
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: frontend
    ports:
    - port: 80
```

Allow frontend to backend on port 80:

- podSelector: backend
- from: frontend
- port: 80

Checklist:

1. Is `podSelector` targeting the correct pods?
2. Is `policyTypes` correct?
3. Is `from`/`to` selector correct?
4. Are namespace labels correct?
5. Is the port correct?
6. Is traffic direction correct?

## Docker

```bash
# Build image
docker build -t myapp:v1 .

# Push image
docker push myrepo/myapp:v1

# Run container
docker run --name app -d nginx

# Useful flags
# -d detached
# -p port mapping
# -e env var
# -v volume

# Save image to tar file
docker save myapp:v1 -o myapp.tar
```

## Resource Management

### Requests and Limits

Container-level resource management:

```yaml
resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    cpu: 500m
    memory: 512Mi
```

### LimitRange

Container limits per namespace.

```yaml
apiVersion: v1
kind: LimitRange
metadata:
  name: limits
spec:
  limits:
  - type: Container
    min:
      cpu: 100m
      memory: 128Mi
    max:
      cpu: "1"
      memory: 1Gi
```

### ResourceQuota

Total namespace resource budget:

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-quota
spec:
  hard:
    requests.cpu: "2"
    requests.memory: 4Gi
    limits.cpu: "4"
    limits.memory: 8Gi
```

Object count quota:

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: object-quota
spec:
  hard:
    pods: "10"
    services: "5"
    configmaps: "20"
    secrets: "20"
```
