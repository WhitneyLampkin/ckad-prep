# Lesson 12 Lab: Configuring a Service Account

## Tasks
1. Create a ServiceAccount with the name mynewsa
2. Find the easiest way to run a busybox Pod with the `sleep 3600` command that uses this ServiceAccount

## My Solution

>> IMPORTANT: Instructor mentions to be careful about what they ask for. If they ask for a Pod, create a Pod and not a deployment.

```yaml
k create sa mynewsa
# Probably should use the --dry-run flag
k create deploy sa-deploy --image=busybox -o yaml -- -c sleep 3600 > sa-deploy.yaml
# May be better to use k edit deploy...
kubectl set serviceaccount deployment sa-deploy mynewsa
```

## Instructor's Solution

```yaml
k create sa lab12sa
k get sa
k run busybox-sa --image=busybox -o yaml --dry-run=client -- sleep 3600 > busybox-sa.yaml
vim busybox-sa.yaml
# Look at docs to get the spec info for SA
k explain pod.spec
vim busybox-sa.yaml
k create -f busybox-sa.yaml
# Verify
k get pods busybox-sa -o yaml
```

## My Result

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  annotations:
    deployment.kubernetes.io/revision: "2"
  creationTimestamp: "2024-09-27T20:57:05Z"
  generation: 2
  labels:
    app: sa-deploy
  name: sa-deploy
  namespace: default
  resourceVersion: "700287"
  uid: 1b6e1fc9-4fdd-44cc-b19c-bb2117fc4cf8
spec:
  progressDeadlineSeconds: 600
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      app: sa-deploy
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: sa-deploy
    spec:
      containers:
      - command:
        - -c
        - sleep
        - "3600"
        image: busybox
        imagePullPolicy: Always
        name: busybox
        resources: {}
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
      dnsPolicy: ClusterFirst
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: {}
      serviceAccount: mynewsa
      serviceAccountName: mynewsa
      terminationGracePeriodSeconds: 30
```

## Instructor's Result

```yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: "2024-09-27T21:08:10Z"
  labels:
    run: busybox-sa
  name: busybox-sa
  namespace: default
  resourceVersion: "700623"
  uid: 87cdc1cd-3726-46b0-b4f0-6754e46f5a8f
spec:
  containers:
  - image: busybox
    imagePullPolicy: Always
    name: busybox-sa
    resources: {}
    terminationMessagePath: /dev/termination-log
    terminationMessagePolicy: File
    volumeMounts:
    - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
      name: kube-api-access-tp9m8
      readOnly: true
  dnsPolicy: ClusterFirst
  enableServiceLinks: true
  nodeName: minikube
  preemptionPolicy: PreemptLowerPriority
  priority: 0
  restartPolicy: Always
  schedulerName: default-scheduler
  securityContext: {}
  serviceAccount: lab12sa
  serviceAccountName: lab12sa
  terminationGracePeriodSeconds: 30
  tolerations:
  - effect: NoExecute
    key: node.kubernetes.io/not-ready
    operator: Exists
    tolerationSeconds: 300
  - effect: NoExecute
    key: node.kubernetes.io/unreachable
    operator: Exists
    tolerationSeconds: 300
  volumes:
  - name: kube-api-access-tp9m8
    projected:
      defaultMode: 420
      sources:
      - serviceAccountToken:
          expirationSeconds: 3607
          path: token
      - configMap:
          items:
          - key: ca.crt
            path: ca.crt
          name: kube-root-ca.crt
      - downwardAPI:
          items:
          - fieldRef:
              apiVersion: v1
              fieldPath: metadata.namespace
            path: namespace
```
