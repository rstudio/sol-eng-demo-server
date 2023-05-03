This repository contains Docker assets for the Solutions Engineering Demo server (lovingly known as "Colorado").

## Disclaimers

These images are stored in AWS ECR, they are _not_ accessible on DockerHub.

We love open source!! However, these resources have a very narrow vision for a very specific environment. Posit uses these images for our Posit Workbench demo environment ("Colorado"). This image builds off of the[r-session-complete](https://github.com/rstudio/rstudio-docker-products/tree/dev/r-session-complete) image. It serves as a great example to get started with building your own Posit Workbench session images.

## Dev Workflow

### Build Pipeline

- All branches / PRs are built on Jenkins
- Only `master` pushes to the ECR repository

### Run tests locally

Build the image locally:

```bash
just build
```
Run tests:

```bash
just test
```
