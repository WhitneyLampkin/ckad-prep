# Random CKAD Notes

## My Most Annoying Concepts
**Using Commands**
- Docker: `ENTRYPOINT` --> K8S: `command`
- Docker: `CMD` --> K8S: `args`
- Mental Model
  - Do I need shell features (&&, |, etc.)?
    - Yes: Use `sh -c`
    - No: Use `--`

## Other Notes
`> [file_name]` - output to file
`k describe pod [pod_name] | grep -i status:` - output the current status of a pod
