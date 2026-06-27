# CKAD Closed Book Drills

1. ConfigMap Drills

CM-1: Environment Variable

Create:

* ConfigMap
* Pod consuming a single key as an env var

⸻

CM-2: envFrom

Create:

* ConfigMap with multiple keys
* Pod importing all keys

⸻

CM-3: Volume Mount

Create:

* ConfigMap
* Pod mounting as files

⸻

CM-4: Specific Key Mapping

Create:

* ConfigMap with multiple keys
* Mount only one key as a file

⸻

CM-5: Deployment Consumption

Create:

* ConfigMap
* Deployment consuming ConfigMap

⸻

2. Secret Drills

S-1: Secret as Env Var

Create:

* Secret
* Pod consuming secret values

⸻

S-2: Secret via envFrom

Create:

* Secret with multiple keys
* Import entire Secret

⸻

S-3: Secret Volume

Create:

* Secret
* Mount as files

⸻

S-4: Single Secret Key Mapping

Create:

* Secret with multiple keys
* Mount one key

⸻

S-5: Deployment Using Secret

Create:

* Secret
* Deployment consuming Secret

⸻

3. Volume Drills

V-1: emptyDir

Create:

* Multi-container Pod
* Shared emptyDir

⸻

V-2: PVC

Create:

* PVC
* Pod mounting PVC

⸻

V-3: Deployment + PVC

Create:

* Deployment
* PVC mount

⸻

V-4: ConfigMap Volume

Create:

* ConfigMap volume mount

⸻

V-5: Secret Volume

Create:

* Secret volume mount

⸻

4. Service Drills

SV-1: ClusterIP

Create:

* Deployment
* ClusterIP Service

Verify endpoints.

⸻

SV-2: NodePort

Create:

* Deployment
* NodePort Service

⸻

SV-3: Service Selector Fix

Create:

* Broken selector
* Repair connectivity

⸻

SV-4: Multiple Ports

Create:

* Service exposing multiple ports

⸻

SV-5: Service + Ingress

Create:

* Service
* Ingress routing to Service

⸻

5. Probe Drills

P-1: HTTP Readiness

Add readiness probe.

⸻

P-2: HTTP Liveness

Add liveness probe.

⸻

P-3: TCP Probe

Add TCP probe.

⸻

P-4: Exec Probe

Add exec probe.

⸻

P-5: Startup Probe

Add startup probe.

⸻

6. Security Context Drills

SC-1: Pod Security Context

Configure:

* runAsUser
* runAsGroup
* fsGroup

⸻

SC-2: Container Security Context

Configure:

* allowPrivilegeEscalation
* readOnlyRootFilesystem

⸻

SC-3: Non-Root Container

Create workload running as non-root.

⸻

SC-4: Drop Capabilities

Configure capability restrictions.

⸻

7. ServiceAccount + RBAC Drills

RBAC-1

Create:

* ServiceAccount
* Pod using it

⸻

RBAC-2

Create:

* ServiceAccount
* Role
* RoleBinding

⸻

RBAC-3

Troubleshoot permission denied error.

⸻

RBAC-4

Switch Pod to correct ServiceAccount.

⸻

8. Deployment Drills

D-1

Basic Deployment.

⸻

D-2

Deployment with replicas.

⸻

D-3

Deployment with resource limits.

⸻

D-4

Deployment with probes.

⸻

D-5

Deployment with ConfigMap.

⸻

D-6

Deployment with Secret.

⸻

D-7

Deployment with PVC.

⸻

D-8

Deployment with everything combined.

⸻

9. Networking Drills

N-1

Ingress routing.

⸻

N-2

Multiple Ingress paths.

⸻

N-3

Ingress path type correction.

⸻

N-4

NetworkPolicy allowing traffic.

⸻

N-5

NetworkPolicy denying traffic.

⸻

N-6

NetworkPolicy using pod selectors.

⸻

N-7

NetworkPolicy using namespace selectors.

⸻

10. Update & Recovery Drills

U-1

Image update.

⸻

U-2

Rollback.

⸻

U-3

Deployment history inspection.

⸻

U-4

Pause rollout.

⸻

U-5

Resume rollout.

⸻

11. Scheduling Drills

C-1

Job.

⸻

C-2

CronJob.

⸻

C-3

CronJob with history limits.

⸻

C-4

Modify schedule.

⸻

Exam-Week Priority (Most Valuable)

If you only have a few days, repeatedly build these from scratch until they’re automatic:

1. Deployment + Resources + Readiness Probe
2. ConfigMap → env
3. ConfigMap → volume
4. Secret → env
5. Secret → volume
6. PVC → Pod
7. ClusterIP Service
8. NodePort Service
9. ServiceAccount + Role + RoleBinding
10. Rolling Update + Rollback
11. Ingress
12. NetworkPolicy
13. CronJob
14. SecurityContext
15. Combined Deployment (ConfigMap + Secret + PVC + Probe + Resources)