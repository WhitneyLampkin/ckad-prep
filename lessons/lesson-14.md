# Lesson 14 - Troubleshooting Kubernetes
- We first need to have the proper understanding of how objects and resources work in Kubernetes.

## Understanding Pod Startup
- Pods are created with `k create` or `k run` and the reequested resources are added to the ETCD db
- Scheduler finds a node to run the application
- Pod image is fetched (downloaded from registry)
- Pod container is started and runs the entrypoint application
- RestartPolicy is applied to determine next step after success or failure of the previous step

## Understanding Pod States
- Pod state is retrieved with `k get pods`

**The different Pod states:**
| State | Validated by api-server | Added to ETCD | Met Pre-reqs | Running | Completed | Failed | Restarted | 
| :----- | :-----------------------: | :-------------: | :------------: | :-------: | :---------: | :------: | :---------: |
| Pending | ⭐ | ⭐ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Running | ⭐ | ⭐ | ⭐ | ⭐ | ❌ | ❌ | ❌ |
| Completed | ⭐ | ⭐ | ⭐ | ⭐ | ⭐ | ❌ | ❌ |
| Failed | ⭐ | ⭐ | ⭐ | ⭐ | ⭐ | ⭐ | ❌ |
| CrashLoopBackOff | ⭐ | ⭐ | ⭐ | ⭐ | ⭐ | ⭐ | ⭐ |
| Unknown | --- | --- | --- | --- | --- | --- | --- |

## Understanding Services
- Services load balance between available Pods
  - Remember there are 3 networks: Node network, Cluster network and Pod network
  - Services use selector labels to match to the appropriate pods
- Troubleshooting Services
  - Start by checking the labels on both the services and the pods
  - Use `k get endpoints` to check Services and corresponding Pod endpoints
 
## Understanding Ingress (Troubleshooting Ingres is NOT on the CKAD exam)
- Ingress uses either a ClusterIP or NodePort Service to forward external traffic to Pods
- Pod labels are used
- Requires an ingress controller to be configured and running

## Understanding NetworkPolicy
- NetworkPolicies can be applied to Pods, Namespaces and IP address ranges to retrict traffic in both directions
- Troubleshooting NetworkPolicies
  - Use `k get netpol -A` to check that NetworkPolicies exist

## Understanding the Network add-on
- There are different network add-ons are available for Kubernetes
- Changing network add-ons can create or fix network related problems
- Flannel, for instance, doesn't support NetworkPolicy and can thus break networking
- **Calico is an add-on that has the richest support.**

## Troubleshooting Authentication Problems (Not on CKAD exam)
- RBAC configurations NOT on CKAD
- Access to clusters configured using kube config files (~/.kube/config)
- The kube config file is copied from teh control node in the cluster, where is it stored as /etc/kubernetes/admin.conf
- `k config view` - to view the config file
- Troubleshooting auth problems
  - `k auth can-i` - used to troubleshoot auth based problems
  - Troubleshooting RBAC based access is covered in CKS
 
## Understanding Probes
- Probes are used to test access to Pods
- Added to pod.spec

| Probe | Description |
| ----- | ----------- |
| readinessProbe | checks that the Pod can be access before its published for use in the cluster |
| livenessProbe | continuously checks the availability of a Pod |
| startupProbe | used with legacy apps that need more startup time on first initialization |

## Understanding Probe Types
- Probes are a simple commandline test

| Probe Type | Description |
| ----- | ----------- |
| `exec`| executes a command and returns exit 0 value if successful |
| `httpGet` | successful HTTP request returns response code between 200 and 399 |
| `tcpSocket` | connectivity to a TCP socket (available port) is successful |

- K8s API has 3 endpoints that indicate the current status of the API Server
  1. /healtz
  2. /livez
  3. /readyz
- The endpoints above can be used by different probes.
