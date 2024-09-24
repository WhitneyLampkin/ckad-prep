# Lesson 7 Lab: Managing Deployments

1. Create a YAML file that starts a deployment for nginx. It should use image version 1.9 and start 5 replicas. The deployment should have teh label `type=proxy`.
2. Configure the deployment such that when it is upgraded, no more than 2 pods will be unavailable at the same time.
