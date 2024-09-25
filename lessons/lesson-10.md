Lesson 10: Managing Kubernetes Storage

## 10.1 Understanding Kubernetes Storage Options

- Container files die when the container is deleted
- Pod Volumes allocate storage that outlives the container and is available according to the pod's lifecycle
- PV can directly bind to specific storage types
- PV use Persistent Volume Claims (PVC) to decouple the pod from requested site-specific storage
- PV defines access to external storage available to a cluster
- PVC connect to PVs
- PVCs search for avaiable PCs that match the storage reqeust
- If no match is found, StorageClass automatically allocates it and the pod uses the PVC storage type

## 10.2 Configuring Pod Volume Storage

- Volumes are defined in pod.spec.volumes
- Volumes point to specific volume types
  - Testing: emptyDir, hostPath
  - Other types are available too
- Volumes are mounted through pod.spec.containers.volumeMounts
