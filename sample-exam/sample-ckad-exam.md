# Sample CKAD Exam Questions

Exam Tips
- Be fast and use the most efficient tools
- Don't write YAML from scratch but generate it
- Train using kubernetes.io/docs
- Don't forget the kubectl cheat sheet: https://kubernetes.io/docs/reference/kubect|/cheatsheet/
- Use kubectl explain a lot
- Make sure you know how to deal with Kubernetes Namespaces

Sample Question Overview
Working with Namespaces
- Create a Namespace ckad-ns1 in your cluster. In this Namespace, run the following Pods:
  1. A Pod with the name pod-a, running the httpd server image
  2. A Pod with the name pod-b, running the nginx server image as well as the alpine image
- Using Secrets
  - Create a Secret that defines the variable password=secret. Create a Deployment with the name secretapp, which starts the nginx image and uses this variable.

Sample Question Overview
Creating Custom Images
- Create a Dockerfile that runs an alpine image with the command "echo hello world" as the default command. Build the image, and export it in OCl format to a tar file with the name "greetworld"

Sample Question Overview
Using Sidecars
- Create a Multi-container Pod with the name sidecar-pod, that runs in the ckad-ns3 Namespace
  - The primary container is running busybox, and writes the output of the date command to the /var/log/date.log file every 5 seconds
  - The second container should run as a sidecar and provide nginx web-access to this file, using an hostPath shared volume. (mount on /usr/share/nginx/html)
  - Make sure the image for this container is only pulled if it's not available on the local system yet

Sample Question Overview
Fixing a Deployment
- Start the Deployment from the redis.yaml file in the course Git repository.
- Fix any problems that may occur while starting it.
- Using Probes
- Create a Pod that runs the nginx webserver
- The webserver should be offering its services on port 80 and run in the ckad-ns3 Namespace
- This Pod should check the /healthz path on the API-server before starting the main container

Sample Question Overview
Creating a Deployment
Write a manifest file with the name nginx-exam.yaml that meets the following requirements:
- It starts 5 replicas that run the nginx:1.18 image
- Each Pod has the label type=webshop
- Create the Deployment such that while updating, it can temporarily run 8 application instances at the same time, of which 3 should always be available
- The Deployment itself should use the label service=nginx
- Update the Deployment to the latest version of the nginx image

Sample Question Review
Exposing Applications
In the ckad-ns6 Namespace, create a Deployment that runs the nginx 1.19 image and give it the name nginx-deployment
- Ensure it runs 3 replicas
- After verifying that the Deployment runs successfully, expose it such that users that are external to the cluster can reach it by addressing the Node Port 32000 on the Kubernetes Cluster node
-  Configure Ingress to access the application at mynginx.info

Sample Question Overview
Using NetworkPolicies
Create a YAML file with the name my-nw-policy that runs two Pods and a
NetworkPolicy
- The first Pod should run an Nginx server with default settings
- The second Pod should run a busybox image with the sleep 3600 command
- Use a NetworkPolicy to restrict traffic between Pods in the following way:
- Access to the nginx server is allowed for the busybox Pod
- The busybox Pod is not restricted in any way

Sample Question Overview
Using Storage
All objects in this assignment should be created in the ckad-1311 Namespace.
- Create a PersistentVolume with the name 1311-pv. It should provide 2 GiB of storage and read/write access to multiple clients simultaneously. Use the hostPath storage type
Next, create a PersistentVolumeClaim that requests 1 GiB from any PersistentVolume that allows multiple clients simultaneous read/write access. The name of the object should be 1311-pvc
- Finally, create a Pod with the name 1311-pod that uses this PersistentVolume. It should run an nginx image and mount the volume on the directory /webdata

Sample Question Overview
Using Quota
- Create a Namespace with the name limited, in which 5 Pods can be started and a total amount of 1000 millicore and 2 GiB of RAM is available Run a Deployment with the name restrictginx in this Namespace, with 3 Pods where every Pod initially requests 64 MiB RAM, with an upper limit of 256 MiB
- RAM

Sample Question Overview
Creating Canary Deployments
- Run a Deployment with the name myweb, using the nginx:1.14 image and 3 replicas. Ensure this Deployment is accessible through a Service with the name canary, which uses the NodePort Service type.
- Update the Deployment to the latest version of Nginx, using the canary Deployment update strategy, in such a way that 40% of the application offers access to the updated application and 60% still uses the old application.

Sample Question Overview
Managing Pod Permissions
- Create a Pod manifest file to run a Pod with the name sleepybox. It should run the latest version of busybox, with the sleep 3600 command as the default command. Ensure the primary Pod user is a member of the supplementary group 2000 while this Pod is started.
- Using a ServiceAccount
- Create a Pod with the name allaccess. Also create a Service Account with the name allaccess and ensure that the Pod is using the ServiceAccount. Notice that no further RBAC setup is required.

