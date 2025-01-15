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

### Blue/Green Deployments
- Overview
  - Different versions of the application exists in different deployments
    - **Blue** is the existing prod deployment
    - **Green** is the new deployment to test
  - Both deployments have their OWN services with labels for the env and selectors to target the intended deployment on different ports
    - There can even be multiple services for one deployment type (i.e. Blue may have public and test services)

### Changing from Blue to Green
- Simply change the selector of the deployment's Service
- Declaratively
  ```shell
  vim [DEPLOYMENT_NAME].yaml

  # Update yaml file

  k apply -f [DEPLOYMENT_NAME].yaml
  ```
- Imperatively
  ```shell
  k set selector svc [SERVICE_NAME] '[SELECTOR_NAME]=[SELECTOR_VALUE]'
  ```

## Understand Deployments and How to Perform Rolling Updates

## use the Helm Package Manager to Deploy Existing Packages
