# Lesson 13 Lab: Using Canary Deployments

1. Run an nginx Deployment that meets the following requirements
   - Use a ConfigMap to provide an index.html file containing the text "welcome to the old version"
   - Use image version 1.14
   - Run 3 replicas
2. Use the canary Deployment upgrade strategy to replace with a newer version of the application
   - Use a ConfigMap to provide an index.html in the new application, containing the text "welcome to the new version"
   - Set the image version to latest
3. Complete the transition such that the old application is completely removed after verifying successful working of the updated application
