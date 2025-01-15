# CKAD: Application Deployment

## Use K8s Primitives to Implement Common Deployment Strategies

### K8s Deployment Options:
- Rolling Updates
- Blue/Green Deployments
- Canary Deployments
- Rollbacks

### Creating Deployments
- Declaratively
  ```yaml
  # TODO: Add code later
  ```
- Imperatively
  ```shell
  k create deployment [DEPLOYMENT_NAME] --image=[IMAGE_NAME} --dry-run=client -o yaml [FILE_NAME].yaml
  k create -f [DEPLOYMENT_NAME].yaml
  ```

### Scaling Deployments
- Declaratively
  ```shell
  vim [DEPLOYMENT_NAME].yaml

  # Update yaml file

  k apply -f [DEPLOYMENT_NAME].yaml
  ```
- Imperatively
  ```shell
  k scale deployment [DEPLOYMENT_NAME] --replicas=[#]
  ```

### Changing a Deployment Image
  ```shell
  vim [DEPLOYMENT_NAME].yaml

  # Update yaml file

  k apply -f [DEPLOYMENT_NAME].yaml
  ```
- Imperatively
  ```shell
  k set image deployment/[DEPLOYMENT_NAME] [NEW_IMAGE_NAME]
  ```

## Understand Deployments and How to Perform Rolling Updates

## use the Helm Package Manager to Deploy Existing Packages
