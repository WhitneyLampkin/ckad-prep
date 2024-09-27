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
• This is convenient for applying changes to input files that the user does not control himself, and which contents may change because of new versions appearing in Git
• Use kubectl apply -k./ in the directory with the kustomization.yaml and the files it refers to to apply changes

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

• Blue/green Deployments are a strategy to accomplish zero downtime application upgrade
• Essential is the possibility to test the new version of the application before taking it into production
• The blue Deployment is the current application
• The green Deployment is the new application
• Once the green Deployment is tested and ready, traffic is re-routed to the new application version
• Blue/green Deployments can easily be implemeted using Kubernetes
Services

## Procedure Overview

• Start with the already running application
• Create a new Deployment that is running the new version, and test with a temporary Service resource
• If all tests pass, remove the temporary Service resource
• Remove the old Service resource (pointing to the blue Deployment), and immediately create a new Service resource exposing the green Deployment
• After successful transition, remove the blue Deployment
• It is essential to keep the Service name unchanged, so that front-end resources such as Ingress will automatically pick up the transition
