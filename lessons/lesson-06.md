# Lesson 6: Managing Pods Advanced Features

One of my favorite concepts learned this lesson is how to run port-forwarding as a background process and call the command back to the foreground to terminate:

```yaml
# Start port-forwarding running in background
k port-forward  [POD_NAME] 8080:80 &
# ctrl+c to return to bash while running in the background
# Test the port.
curl localhost:8080
# Return to foreground
fg
# ctrl+c to terminate port-forwarding!
```

Also learned that by running a job, we're basically running a pod.

`k get all` - Get all resources in a cluster!
`k get resourcetype1,resourcetype2` - Returns only the resources for the listed resource types using commas with NO SPACES!
