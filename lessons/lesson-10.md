Lesson 10: Managing Kubernetes Storage

## 10.1 Understanding Kubernetes Storage Options

- Container files die when the container is deleted
- Pod Volumes allocate storage that outlives the container and is available according to the pod's lifecycle
- PV can directly bind to specific storage types
- PV use Persistent Volume Claims (PVC) to decouple the pod from requested site-specific storage

