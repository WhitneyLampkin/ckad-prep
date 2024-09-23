# Lesson 6 Demos

## Running a Pod with Limitations

```yaml
k create -f frontend-resources.yaml
k get pods
k describe pod frontend
k delete -f frontend-resources.yaml
```

## Using Quota

```yaml
k create ns restricted
k create quota myquota -n resitrcted --hard=cpu=2,--memory=1G,pods=3
k describe ns restricted
# The next command should fail.
k run pod restrictedpod --image=nginx -n restricted
k create deploy restricteddeploy --image=nginx -n restricted
k set resources -n restricted deploy restrictedeploy --limits=cpu=200m,memory=2G
k describe -n restricted deploy restricteddeploy
k set resources -n restricted deploy restricteddeploy --limits=cpu=200m,memory=128M --requests=cpu=100m,memory=64M
```
