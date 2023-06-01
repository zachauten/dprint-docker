# dprint-docker
Dockerized [dprint](https://dprint.dev/), with support for [java](https://github.com/google/google-java-format) (maybe more later)

## building image
docker -t dprint .

## running image
You will need to mount the source code that you're formatting to the container.
It's easier to mount it to a subdirectory of the image's workdir, /app.

`docker run --rm -it -v $(pwd)/src:/app/src dprint check`

