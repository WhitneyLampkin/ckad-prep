# Lesson 5: Managing Pod Basic Features

## 5.1 Understanding Pods

## 5.2 Understanding YAML
- `kubectl explain [RESOURCE_NAME]`
- `kubectl explain [RESOURCE_NAME | less` - uses less to make it easier to navigate and read lots of output
- `kubectl example pod.spec | less` - example usage to get more information about the pod.spec
- `kubectl explain --recursive pod.spec | less` - using `--recursive` is helpful to show the relationship between child and parent items and how they are formatted in yaml
- `vim busybox.yaml` - when ran in the course files directory, it opens the busybox.yaml for the pod in vim
- `kubectl create -f busybox.yaml` - will quickly create pods from the yaml definition; create will throw an error if the pod already exists
- `kubectl delete -f busybox.yaml` - will delete a pod based on the yaml definition
- `kubectl apply -f busybox.yaml` - unlike create, it will create if the pod doesn't exist and update if it does

## 5.3 Generating YAML Files
- 

## 5.4 Undersatnding and Configuring Multi-Container Pods

## 5.5 Working with Init Containers
