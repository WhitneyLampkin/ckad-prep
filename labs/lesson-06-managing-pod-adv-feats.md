# Lesson 6 Lab: Managing Pod Advanced Features

Create a manifest file that defines the secret-app application (pod; not a deployment), which should meet the following requirements:

1. Runs in the namespace secret
2. Uses busybox image to run the command sleep 3600
3. Restart only if it fails
4. Memory request 64 MiB, upper threshold of 128 MiB
