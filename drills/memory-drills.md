🐳🧠 CKAD Memory Drills

Volumes
Persistent storage 
—————————
SPE(E)CH
* Secret
* PersistentVolumeClaim
* EmptyDir
* ConfigMap
* HostPath

Secret
volumes:
- name:
  secret:
    secretName:

volumes:
- name:
  secret:
    secretName:
    items:
      key:
      path:

Secret path in containers:
/var/run/secrets/kubernetes.io/serviceaccount/

PersistentVolumeClaim
volumes:
- name:
  persistentVolumeClaim:
    claimName:

EmptyDir
volumes:
- name:
  emptyDir:

ConfigMap
volumes:
 - name:
   configMap:
     name:

HostPath
volumes:
- name:
  hostPath:
    path:
———————————————

ENV VARS
Configuration via environment variables
—————————————————————
ACE
* All - EnvFrom/Ref/Name
* CM/Secret Key - ValueFrom/KeyRef/Name
* Env - Name/Value

EnvFrom/Ref
env:
- name:
  envFrom:
    configMapRef:
      name:

env:
- name:
  envFrom:
    secretRef:
      name:

ConfigMap/Secret KeyRef
env:
- name:
  valueFrom:
    configMapKeyRef:
      name:
      key:

env:
- name:
  valueFrom:
    secretKeyRef:
      name:
      key:

ENV
env:
- name:
  value:
———————————————

RBAC
Role based access control
————————————
SARB (RBAS)
* SA - Service Account
    * [Update Pod SA name]
* R - Role
* B - RoleBinding

Namespace: Role/RoleBinding
Cluster: ClusterRole/ClusterRoleBinding

B(A)RNS - Failure Modes
* Binding missing or wrong
* Role missing resource or verb permissions 
* Namespace mismatch
* ServiceAccount missing (object or pod link)

kubectl create sa
kubectl create role
kubectl create rolebinding
kubectl apply pod.yaml (with serviceAccountName)

Flow
Service Account (linked to Pod)
  ↓
Role
  ↓
Role Binding
  ↓
Traffic routing

Role.Rules.ApiGroups
Resource type	apiGroups
pods, services, configmaps	""
deployments	apps
jobs	batch
cronjobs	batch
ingresses	networking.k8s.io

Role.Rules.Verbs
get
list
watch
create
update
patch
delete
———————————————

Services
How traffic reaches pods
—————————————
CLE(A)N (C > N > L > E)
* ClusterIp
* Nodeport
* Loadbalancer
* ExternalName

kubectl create service clusterip
kubectl create service nodeport
kubectl create service loadbalancer

spec:
  type: ClusterIP | NodePort | LoadBalancer | ExternalName
  selector:
    key: value
  ports:
  - port:
    targetPort:

Selectors
Services must exactly match pod labels via selectors to know which pods to expose.

Flow
Service
  ↓
Selector
  ↓
Pod labels
  ↓
Traffic routing

Failure Modes
L(A)TTS
* Labels for pods
* Type
* Target Port
* Selectors

1. Do Pods have labels?
2. Does selector match EXACTLY?
3. Is targetPort correct?
4. Is Service type correct?

Mappings
Type	Entry Point
ClusterIP	virtual cluster IP
NodePort	<NodeIP>:port
LoadBalancer	external IP
ExternalName	DNS name
———————————————

Network Policies
Pod-level traffic (firewalls) ; allow or restrict traffic to pods using labels. 
————————————
* Linked via podSelector/matchLabels
* Default - allow all

apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-something
spec:
  podSelector | namespaceSelector:
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

# “Allow frontend to backend on port 80”
# PFP
podSelector: backend
from: frontend
port: 80

1. Is podSelector targeting the correct Pods?
2. Is policyType correct?
3. Is from/to selector correct?
4. Are namespace labels correct?
5. Is the port correct?
6. Is traffic direction correct?
———————————————

Docker
# docker build -t <image>:<tag> 
docker build -t myapp:v1 .

# docker push <image>
docker push myrepo/myapp:v1

docker run --name app -d nginx
# -d  detached
# -p  port mapping
# -e  env var
# -v  volume

# save image -o file.tar
docker save myapp:v1 -o myapp.tar
———————————————

Resource Management

Requests & Limits
Container level resource management 
resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    cpu: 500m
    memory: 512Mi

LimitRanges
Container limits per namespace

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

ResourceQuotas
Total namespace resource budget

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

# Object counts
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
