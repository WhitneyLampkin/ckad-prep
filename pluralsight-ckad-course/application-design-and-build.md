# Application Design and Build

## Define Build and Modify Container Images

```shell
# View Dockerfile in current directory
cat Dockerfile

# Build image from Dockerfile in current directory
docker image build -t [REPOSITORY]:[TAG] .

# View all images
docker image ls

# Pull an image
docker image pull [REPOSITORY]:[TAG]

# Save image to tar file
docker save [REPOSITORY]:[TAG] --output [FILE_NAME].tar
# ...or use gzip
docker save [REPOSITORY]:[TAG] | gzip > image.tar.gz

# Create image from a running container
docker commit [CONTAINER] [IMAGE_NAME]

# Rename or retag an image
docker image tag [OLD_REPOSITORY]:[OLD_TAG] [NEW_REPOSITORY]:[NEW_TAG]

# Delete image (only works if no containers are using them)
docker image rm [REPOSITORY]:[TAG]

# Use docker help
docker --help
docker [COMMAND] --help
```

## Understand Jobs and CronJobs

```shell
# View existing manifeswts
vi [FILE_NAME].yaml

# Creating CronJobs from Jobs
# Get CronJob template from K8s docs and copy over the `spec` contents from the existing Job manifest.

# Create CronJob from yaml
k apply -f [FILE_NAME].yaml

# View CronJobs in cluster
k get cronjobs

# See a cronjob's jobs
k get jobs

# A job's pods
k get pods

# If a CronJob controller occassionally misses jobs, check that the startingDeadlineSeconds is >= 10 seconds.

# To always keep logs after job runs use `restartPolicy: Never`.
```

## Understand Multi-Container Pod Design Patterns

```shell

```

## Utilize Persistent and Ephemeral Volumes

```shell

```

## Reminders
- Pay attention to nested sections in the manifest files for each K8s object.
- `docker -f` flag can be used to specify a DOCKERFILE in a different directory.
- Local image names must match the remote repository name or image pushes will fail in Docker.
- <TODO - Check if `docker` has an `oci-archive` tag.>
- Job properties to remember: `activeDeadlineSeconds`, `ttlSecondsAFterFinsihed`, `completions`, `parallelism` and `backoffLimit`.
- CronJob properties to remember: `schedule`, `startingDeadlineSeconds`, `concurrencyPolicy`, `successfulJobsHistoryLimit`, and `failedJobsHistoryLimit`.
  - Only `spec.schedule` is required for cronjobs.
  - `schedule`: "* * * * *" means run every minute.
  - Setting CronJob `startingDeadlineSeconds` to less than 10 seconds can cause jobs to be missed since CronJobs run every 10 seconds.
- Timezone is based on the K8s API Server for the cluster. Keep this in mind when scheduling jobs and cronjobs.
- `Step Values` can be used when scheduling CronJobs to schedule for `*/2` or every 2 hours.
