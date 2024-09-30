# Lesson 13: Deploying Applications the DevOps Way

## Understanding Helm
- Helm streamlines installing and managing Kubernetes applications
- Helm contains the helm commandline tool, must install, and a chart
- Helm Charts - helm package that includes:
  - Description of the package
  - One or more templates containing Kubernetes manifest files
- Charts are stored locally or accessed from remote Helm repositories

## Getting Access to Helm Charts
- artifacthub.io - main website to get Helm charts from
- Example: Install Kubernetes Dashboard
  - `helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard`
  - `helm install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard`
- Minikube installation of Helm - `minikube addons enable dashboard`

## Kustomize
kustomize is a Kubernetes feature, that uses a file with the name kustomization.yaml to apply changes to a set of resources
- This is convenient for applying changes to input files that the user does not control himself, and which contents may change because of new versions appearing in Git
- Use kubectl apply -k./ in the directory with the kustomization.yaml and the files it refers to to apply changes

## Understanding Kustomise Yaml Files

```yaml
resources:
# defines which resources (in YAML files) apply.
- deployment.yaml
- service.yaml
namePrefix: test- # specifies a prefix should be added to all names namespace: testing # objects will be created in this specific
namespace
commonLabels: # labels that will be added to all objects environment: testing
```

## Understanding Blue/Green
- Blue/green Deployments are a strategy to accomplish zero downtime application upgrade
- Essential is the possibility to test the new version of the application before taking it into production
- The blue Deployment is the current application
- The green Deployment is the new application
- Once the green Deployment is tested and ready, traffic is re-routed to the new application version
- Blue/green Deployments can easily be implemeted using Kubernetes
Services

## Procedure Overview
- Start with the already running application
- Create a new Deployment that is running the new version, and test with a temporary Service resource
- If all tests pass, remove the temporary Service resource
- Remove the old Service resource (pointing to the blue Deployment), and immediately create a new Service resource exposing the green Deployment
- After successful transition, remove the blue Deployment
- It is essential to keep the Service name unchanged, so that front-end resources such as Ingress will automatically pick up the transition

## Understanding Canary Deployments
- A canary Deployment is an update strategy where you first push the update at small scale to see if it works well
- In terms of Kubernetes, you could imagine a Deployment that runs 4 replicas
- Next, you add a new Deployment that uses the same label
- Then you create a Service that uses the same selector label for all
- As the Service is load balancing, only 1 out of 5 requests would be serviced by the newer version
- And if that doesn't seem to be working, you can easily delete it

## Understanding Operators and Controllers
- Operators can be added to Kubernetes by developing them yourself
- Operators are also available from community websites
- A common registry for operators is found at operatorhub.io (which is rather
OpenShift oriented)
- Many solutions from the Kubernetes ecosystem are provided as operators
- Prometheus: a monitoring and alerting solution
- Tigera: the operator that manages the calico network plugin
- Jaeger: used for tracing transactions between distributed services

## Understanding StatefulSet
- The main purpose of a StatefulSet is to provide a persistent identity to Pods as well as the Pod-specific storage
- Each Pod in a StatefulSet has a persistent identifier that it keeps across rescheduling
- StatefulSet provides ordering as well
- Using StatefulSet is valuable for applications that require any of the following
- Stable and unique network identifiers
- Stable persistent storage
- Ordered deployment and scaling
- Ordered automated rolling updates

## Understanding StatefulSet Limitations
Storage Provisioning based on StorageClass must be available
- To ensure data safety, volumes created by the StatefulSet are not deleted while deleting the StatefulSet
- A Headless Service must be created to provide application access
- To guarantee removal of StatefulSet Pods, scale down the number of Pods to 0 before removing the StatefulSet
