## Lesson 11: Managing ConfigMaps and Secrets

## 11.3 Providing Variables with ConfigMaps

- `k create cm` - creates new ConfigMap, variables can be provided 2 ways:
  - `--from-env-file`: Example - `k create cm --from-env-file=[FILE]`
  - `--from-literal`: Example - `k create cm --from-literal=[KEY]=[VALUE]`
- Multiple vars can be specified with from literal but only 1 file can be used with from-env-file
- ConfigMaps have to be added to deployments after creation
  - `k set env --from=configmap/[CM_NAME] deploy/[DEPLOYMENT_NAME]`
- `dry-run=client` can be used during ConfigMap creation
