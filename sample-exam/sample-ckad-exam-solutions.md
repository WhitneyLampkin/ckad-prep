# Sample Exam Solutions

## Working with Namespaces

### My Solution
```yaml
k create ns ckad-ns1
k run pod-a --image=httpd -n ckad-ns1
k run pod-b --image=nginx -n ckad-ns1
```

### Instructor's Solution
```yaml
k create ns ckad-ns1
# Verify
k get ns
k run pod-a --image=httpd -n ckad-ns1
k run pod-b -n ckad-ns1 --image=alpine --dry-run=client -o yaml -- sleep 3600 > task1.yaml # On exam, name yaml files by question number
vi task1.yaml
# Update yaml as needed for requirements
k create -f task1.yaml
k get pods -n ckad-ns1
```

## **Using Secrets

### My Solution
```yaml
k create secret generic my-secret --from-literal=password=secret
# Verify
k get secrets
k create deploy secretapp --image=nginx
k set env --from=secret/my-secret deployment/secretapp
# Verification
k exec -it secretapp-7f8f9d4f9-h557n -- sh
  # env
```

### Instructor's Solution
```yaml
k create secret generic my-secret --from-literal=password=secret
k describe secret my-secret
k create deploy secretapp --image=nginx
k set env --from=secret/my-secret deployment/secretapp # cannot pass env var while creating deployments with kubectl
# Verify
k get pods # look for secret app
k exec secretapp-7f8f9d4f9-h557n -- env # this is more streamlined than my method
```

## ** Creating Custom Images (skipped)

### My Solution
```yaml
# No attempt
# Create dockerfile
vi [FILE_NAME]
# update file contents
docker build -t .
```

### Instructor's Solution
```yaml
vim DOCKERFILE

# update dockerfile
  FROM alpine
  CMD ["echo", "hello world"]

# Build iamge
docker build -t greetworld .

# Verify
docker images

# Export
docker save --help
docker save -o greetworld.tar greetworld

# Verify
ls -l # look for tar file

# For OCI, no changes are needed because DOCKERFILES are OCI compliant by default.
```

## **Using Sidecars (skipped)

### My Solution
```yaml
k create ns ckad-ns3
k run sidecar-pod -n ckad-ns3 --image=busybox --image=nginx -o yaml --dry-run=client > scpod.yaml
vi scpod.yaml
```

### Instructor's Solution
```yaml
# Find Sidecar documentation, which includes the shared data and containers
# Need to find the doc named 'Communicate Between Containers in the Same Pod Using a Shared Volume'
# Update template
# Search doc for setting up hostPath

# To get the command syntax, generate template code
k run busybox --dry-run=client -o yaml -- sh -c "while sleep 5; do date >> /var/log/date.log; done"

# Copy generated command code into pod manifest
apiVersion: v1
kind: Pod
metadata:
  name: sidecar-pod
  namespace: ckad-ns3
spec:

  restartPolicy: Never

  volumes:
  - name: shared-data
    hostPath:
      path: /mydata

  containers:

  - name: nginx-container
    image: nginx
    volumeMounts:
    - name: shared-data
      mountPath: /usr/share/nginx/html

  - name: busybox-container
    image: busybox
    volumeMounts:
    - name: shared-data
      mountPath: /var/log
    - args: # this will fail because of incorrect indentation; will need to remove the hyphen
      - sh
      - c
      - while sleep 5; do date >> /var/log/date.log; done

k create -f [POD_FILE].yaml # Fails because of indentation

# Fix -args to args

apiVersion: v1
kind: Pod
metadata:
  name: sidecar-pod
  namespace: ckad-ns3
spec:

  restartPolicy: Never

  volumes:
  - name: shared-data
    hostPath:
      path: /mydata

  containers:

  - name: nginx-container
    image: nginx
    volumeMounts:
    - name: shared-data
      mountPath: /usr/share/nginx/html

  - name: busybox-container
    image: busybox
    volumeMounts:
    - name: shared-data
      mountPath: /var/log
    args:
      - sh
      - c
      - while sleep 5; do date >> /var/log/date.log; done

k create -f scpod.yaml
k exec sidecar-pod -n ckad-ns3 -it -- /bin/sh
# Inside of container
  ls -a # look for specified file
  cat /usr/share/nginx/html/date.log
```

## Fixing a Deployment

### My Solution
```yaml
k apply -f redis.yaml
# Error because resource wasn't found in defined api version; changed from v1beta1 to v1
k api-resources
k apply -f redis.yaml
k run nginx --image=nginx -o yaml --dry-run=client --port=80 -n ckad-ns3 > nginx.yaml
vim nginx.yaml
# Add template code for probe from docs
k create ns ckad-ns3
k apply -f nginx.yaml
```

### Instructor's Solution
```yaml
vim redis.yaml
k create -f redis.yaml
# Error message
k api-versions # shows supported version of each api resource
# Edit file to use v1
k create -f redis.yaml # Succeeds
```

## Using Probes

### My Solution
```yaml
k run nginx --image=nginx -o yaml --dry-run=client --port=80 -n ckad-ns3 > nginx.yaml
vim nginx.yaml
# Add template code for probe from docs
k create ns ckad-ns3
k apply -f nginx.yaml
```

### Instructor's Solution
```yaml
# Docs - search for healthz api
# Kubenetes API Endpoints doc
# Get curl command - curl -k https://[IP]:[PORT]/healthz?verbose
curl -k https://$(minikube ip):8443/healthz?verbose
echo $? # shoudl show 0
# Get api advertise address
minikube ssh
ps aux | grep api
k get pods -n kube-system -o wide # Can also get the ip address this way for api server

# Go back to docs and search for probes
# Copy liveness probe into manifest file and update

apiVersion: v1
kind: Pod
metadata:
  labels:
    test: liveness
  name: liveness-exec
  namespace: ckad-ns3
spec:
  containers:
  - name: nginx
    image: nginx
    ports:
      containerPort: 80
    readinessProbe:
      exec:
        command:
        - curl
        - k
        - https://$192.168.49.2:8443/healthz
      initialDelaySeconds: 5
      periodSeconds: 5

k create -f [POD_NAME].yaml
k get pods
# Wait a few seconds for the probe to run
# Error, as is...troubleshoot
k describe [POD]

# Forgot '-k' instead of 'k'

# Update yaml

apiVersion: v1
kind: Pod
metadata:
  labels:
    test: liveness
  name: liveness-exec
  namespace: ckad-ns3
spec:
  containers:
  - name: nginx
    image: nginx
    ports:
      containerPort: 80
    readinessProbe:
      exec:
        command:
        - curl
        - -k
        - https://$192.168.49.2:8443/healthz
      initialDelaySeconds: 5
      periodSeconds: 5

Recreate pod and verify it runs...
```

## Creating a Deployment

### My Solution
```yaml
kubectl create deployment nging --image=nginx:1.18 --replicas=5 -o yaml --dry-run=client > nginx-exam.yaml
vi nginx-exam.yaml

# Update deployment manifest
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: nginx
    service: nginx
  name: nginx
spec:
  replicas: 5
  selector:
    matchLabels:
      app: nginx
  strategy: {} # This is a duplicate that I forgot to remove
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: nginx
        type: webshop
    spec:
      containers:
      - image: nginx:1.18
        name: nginx
        resources: {}
  strategy:
   type: RollingUpdate
   rollingUpdate:
     maxSurge: 8 
     maxUnavailable: 5

# Create deployment
k apply -f nginx-exam.yaml

# Update deployment image to latest
kubectl set image deployment/nginx nginx=nginx:latest

# Verify
k describe deploy nginx | grep -i image
```

### Instructor's Solution
```yaml
k create deploy nginx-exam --image=nginx:1.18 --dry-run=client -o yaml > nginx-exam.yaml

# modify manifest as needed for requirements

apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: nginx-exam
    service: nginx
  name: nginx-exam
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx-exam
  strategy: {
    rollingUpdate:
     maxSurge: 3
     maxUnavailable: 2
  }
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: nginx-exam
        type: webshop
    spec:
      containers:
      - image: nginx:1.18
        name: nginx
        resources: {}
status: {}

k create -f nginx-exam.yaml
k get all --selector app=nginx-exam

kubectl set image deployment/nginx-exam nginx=nginx:latest

k get all --selector app=nginx-exam
```

## ** Exposing Applications

### My Solution
```yaml
k create deploy nginx-deployment --image=nginx:1.19 --replicas=3
k get deploy nginx-deployment -o yaml
kubectl expose deployment nginx-deployment --port=80 --target-port=8000 --type=NodePort -n ckad-ns6

# How to setup ingress-controller, which is required for using Ingress
# Instructor says we won't have to configure Ingress in /etc/hosts or anything DNS related...
```

### Instructor's Solution
```yaml
# Configure DNS - NOT ON EXAM
sudo vim /etc/hosts
  # Add 192.168.49.2    nginxsvc.info mynginx.info
minikube addons list # Check that ingress is enabled
k create ns ckad-ns6
k create deploy nginx-deployment --image=nginx:1.19 -n ckad-ns6 --replicas=3
k expose -n ckad-ns6 deployment nginx-deployment --port=80
k edit -n ckad-ns6 svc nginx-deployment

# Update port info

apiVersion: v1
kind: Service
metadata:
  creationTimestamp: "2024-10-03T14:08:01Z"
  labels:
    app: nginx-deployment
  name: nginx-deployment
  namespace: ckad-ns6
  resourceVersion: "837888"
  uid: f5fad2cb-1d38-4016-a33d-ec761739a8f2
spec:
  clusterIP: 10.101.48.16
  clusterIPs:
  - 10.101.48.16
  externalTrafficPolicy: Cluster
  internalTrafficPolicy: Cluster
  ipFamilies:
  - IPv4
  ipFamilyPolicy: SingleStack
  ports:
  - nodePort: 32000
    port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: nginx-deployment
  sessionAffinity: None
  type: NodePort
status:
  loadBalancer: {}

# Verify svc now has NodePort Type
k get svc -n ckad-ns6

# Create ingress rule
k create -n ckad-ns6 ingress nginxdeploy --class=default --rule="mynginx.info/=nginx-deployment:80"

# Verify
curl mynginx.info
```

## Using Network Policies

### My Solution
```yaml
k run my-network-policy --image=nginx --image=busybox -o yaml --dry-run=client --port=80 --expose -- /bin/sh sleep 3600 > nwpdeploy.yaml

# Edit yaml with vim
vi nwpdeploy.yaml

k apply -f nwpdeploy.yaml
```

### Instructor's Solution
NETWORK POLICIES ARE ALL ABOUT THE LABELS!!!

```yaml
# Find Network Policy in docs
# Paste in new file using vim
# Find basic pod spec in docs and copy in twice for the two pods
# Update manifest as needed

apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    app: nginx
spec:
  containers:
  - name: nginx
    image: nginx
---
apiVersion: v1
kind: Pod
metadata:
  name: busybox
  labels:
    access: true
spec:
  containers:
  - name: busybox
    image: busybox
    args:
    - sleep
    - "3600"
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: test-network-policy
  namespace: default
spec:
  podSelector:
    matchLabels:
      app: nginx
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          role: frontend

k create -f my-nw-policy.yaml # Create error - boolean in label; needs to be string; change true to allowed
k expose pod nginx --port=80
k exec -it busybox -- wget --spider --timeout=1 nginx # get timeout error

# Need to label busybox pod with role=frontend
k label pod busybox role=frontend

k exec -it busybox -- wget --spider --timeout=1 nginx # should work now
```

## Using Storage
I would have failed because I didn't create in correct namespace.

### My Solution
```yaml
k create ns ckad-1311

# vi pv.yaml
# Add resources

apiVersion: v1
kind: PersistentVolume
metadata:
  name: 1311-pv
spec:
  capacity:
    storage: 2Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteMany
  storageClassName: normal
  hostPath:
    path: /etc/foo
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: 1311-pvc
spec:
  volumeName: 1311-pv
  accessModes:
    - ReadWriteMany
  volumeMode: Filesystem
  resources:
    requests:
      storage: 1Gi
  storageClassName: normal
---
apiVersion: v1
kind: Pod
metadata:
  name: 1311-pod
spec:
  containers:
    - name: nginx
      image: nginx
      volumeMounts:
      - mountPath: "/webdata"
        name: mypd
  volumes:
    - name: mypd
      persistentVolumeClaim:
        claimName: 1311-pvc

# Create resources
k apply -f pv.yaml
```

### Instructor's Solution
NOT EASILY CONFIGURED WITH KUBECTL

```yaml
# Create namespace
k create ns ckad-1312

# Check docs for configuring pod to use PV for storage

vi task1512.yaml

# Add PV and PVC templates from docs

apiVersion: v1
kind: PersistentVolume
metadata:
  name: task-pv-volume
  labels:
    type: local
spec:
  storageClassName: manual
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/mnt/data"
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: task-pv-claim
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 3Gi
---
apiVersion: v1
kind: Pod
metadata:
  name: task-pv-pod
spec:
  volumes:
    - name: task-pv-storage
      persistentVolumeClaim:
        claimName: task-pv-claim
  containers:
    - name: task-pv-container
      image: nginx
      ports:
        - containerPort: 80
          name: "http-server"
      volumeMounts:
        - mountPath: "/usr/share/nginx/html"
          name: task-pv-storage

# Now update the templated values

apiVersion: v1
kind: PersistentVolume
metadata:
  name: 1312-pv
  namespace: ckad-1312
  labels:
    type: local
spec:
  storageClassName: manual
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteMany
  hostPath:
    path: "/mnt/data"
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: 1312-pvc
  namespace: ckad-1312
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 1Gi
---
apiVersion: v1
kind: Pod
metadata:
  name: 1312-pod
  namespace: ckad-1312
spec:
  volumes:
    - name: task-pv-storage
      persistentVolumeClaim:
        claimName: 1312-pvc
  containers:
    - name: task-pv-container
      image: nginx
      ports:
        - containerPort: 80
          name: "http-server"
      volumeMounts:
        - mountPath: "/web/data"
          name: task-pv-container

# Create
k create -f task1512.yaml

# Verify
k -n ckad-1312 get pods,pv,pvc
k exec -n ckad-1312 -it [POD] -- touch /web/data/testfile
minikube ssh
  $ ls /mnt/data # verify that we see the testfile from the hostPath
```

## Using Quota

### My Solution
```yaml
k create ns limited
kubectl create quota my-quota --hard=cpu=1,pods=5,memory=2Gi -n limited
k create deploy restrictginx -n limited --replicas=3 --image=nginx
kubectl set resources deployment restrictginx --limits=memory=256Mi --requests=memory=64Mi -n limited
```

### Instructor's Solution
```yaml
# Create
k create ns limited
k create quota limitedquota -n limited --hard=cpu=1,memory=2G,pods=5

# Verify
k describe ns limited # check for quota settings

# Create deployment and set resources
k create deploy restrictnginx -n limited --replicas=3 --image=nginx 
k set resources -n limited deployment restrictnginx --limits=memory=256Mi --requests=memory=64Mi

# Verify
k get all -n limited

# Error - Not seeing the updates

# k describe -n limited rs [RS_NAME]
# Error - failed limit quota - must specify CPU quota on deployment also!

# Set limites on deployment
k create deploy restrictnginx -n limited --replicas=3 --image=nginx --limits=cpu=1 --requests=cpu=1

# Verify again - need to set minicore...

# Use millicore instead of an entire CPU
k create deploy restrictnginx -n limited --replicas=3 --image=nginx --limits=cpu=200m --requests=cpu=200m

# Delete and recreate adn set limits again
k delete deploy restrictnginx -n limited
k create deploy restrictnginx -n limited --replicas=3 --image=nginx
k create deploy restrictnginx -n limited --replicas=3 --image=nginx --limits=cpu=200m --requests=cpu=200m
k set resources -n limited deployment restrictnginx --limits=memory=256Mi --requests=memory=64Mi

# Verify
k describe ns limited
```

## Creating Canary Deployments

### My Solution
```yaml
k create deploy myweb --image=nginx:1.14 --replicas=3
k expose deploy myweb --type=NodePort --name=canary --port=80
k get deploy myweb -o yaml > canarydeploy.yaml
vi canarydeploy.yaml

# Update deployment with canary values

apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: myweb-canary
  name: myweb-canary
  namespace: default
spec:
  progressDeadlineSeconds: 600
  replicas: 2
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      app: myweb-canary
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: myweb-canary
    spec:
      containers:
      - image: nginx:1.14
        imagePullPolicy: IfNotPresent
        name: nginx
        resources: {}
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
      dnsPolicy: ClusterFirst
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: {}
      terminationGracePeriodSeconds: 30
```

### Instructor's Solution
```yaml
k create deploy myweb --image=nginx:1.14 --replicas=3
k edit deploy myweb

# Add label to deploy, pods and all resources
  # type: canary

# Verify
k get all --selector type=canary

# Expose canary deployment to its own service
k expose deploy myweb --selector type=canary --port=80

# Verify
k describe svc myweb

# Update deployment - means to create a new one for canary?
k create deploy mynewweb --image=nginx:latest --replicas=2

k edit deploy mynewweb

# Set label to type: canary for the new deployment and pods as well


# Verify 5 endpoints
k describe svc myweb
k get ep
```

## Managing Pod Permissions

### My Solution
```yaml
k run sleepybox --image=busybox:latest -o yaml --dry-run=client -- sleep 3600 > pod.yaml
vi pod.yaml
# Get securityContext template from docs and update pod.yaml

# Create service account
k create serviceaccount allaccess
k run pod --image=nginx --dry-run=client -o yaml > pod-aa.yaml
vi pod-aa.yaml

apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod
  name: pod
spec:
  serviceAccountName: allaccess
  automountServiceAccountToken: false
  containers:
  - image: nginx
    name: pod
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

k apply -f pod-aa.yaml
```

### Instructor's Solution
```yaml

```
