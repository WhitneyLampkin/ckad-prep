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
