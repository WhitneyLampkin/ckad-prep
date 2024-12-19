# Define Build and Modify Container Images

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
