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

### Canary Deployments
  - Overview
    - Two identical production environments are run alongside one another with the old/new versions of the app to determine how the new version performs before continuing with the deployment
      - **Canary** is the new app version
      - **Stable** is the existing prod version
    - Both use the **_SAME_** service, which routes a small amount of traffic to the canary deployment
    - After checking performance via metrics, monitors, logs, customers, etc., if all is well, the service is configured to fully point to the canary version
  - K8s resources used for Canary deployments
    - Service
      - Defines a pod label to select for the Service in spec > selector > [SOME_SELECTOR_KV]
    - Stable Deployment
      - Replicas (usually higher number of replicas)
      - Defines pod labels in spec > template > metadata > labels > [SOME_LABEL_KV]
    - Canary Deployment
      - Replicas (usually lower replica number)
      - Defines pod labels in spec > template > metadata > labels > [SOME_LABEL_KV]
  - With this deployment strategy the service points to both deployments using the same port. The different is the number of replicas of each
    - ex. To get 25% of traffic to Canary and 75% to Stable, deploy 1 replica of Canary and 3 replicas of Stable
   
### Creating Stable and Canary Resources
```shell
# ALl at once if in the same folder
k create -f [FOLDER_NAME]

# Individually
k create -f [DEPLOYMENT_NAME].yaml
```

## Understand Deployments and How to Perform Rolling Updates

## use the Helm Package Manager to Deploy Existing Packages




















































