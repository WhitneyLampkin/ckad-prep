# Certified Kubernetes Application Developer (CKAD) Exam Prep
Supplemental notes and cheat sheets to prep for the CKAD certification exam.

[Official Kubectl Quick Reference](https://kubernetes.io/docs/reference/kubectl/quick-reference/)
[CKAD Cheatsheet](https://gist.github.com/WhitneyLampkin/2c2bca9b91ef66ce6d91662f44da1a30)

## Quick Environment Setup
```shell
# set alias for kubectl
alias k=kubectl

# set environment variable for kubectl dry run and output options. Use $do in your kubectl command instead
export do="--dry-run=client -o yaml"

# use kn ns-name to switch namespace quickly
alias kn="kubectl config set-context --current -namespace "
```
