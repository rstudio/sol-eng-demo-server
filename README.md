This repository contains Docker assets for the Solutions Engineering Demo
server (lovingly known as "Colorado").

## Getting Started

Because these images are stored in AWS ECR, they are _not_ easily accessible on
DockerHub.

Rather, you need to know how to:

- [Authenticate to AWS
  ECR](https://docs.aws.amazon.com/AmazonECR/latest/userguide/registries.html#registry_auth)
- [Access AWS ECR
  Registries](https://docs.aws.amazon.com/AmazonECR/latest/userguide/registries.html)

## Disclaimers

We love open source!! However, these resources have a very narrow vision for a
very specific environment. If you are looking for a bit more generic solution
that may apply better to your environment, we suggest you check out some of the
following resources:

- [R Builds](https://github.com/rstudio/r-builds)
- [docker-r-session-complete](https://github.com/sol-eng/docker-r-session-complete),
  which these resources are based on
- [The docker-r-session-complete images](https://hub.docker.com/r/rstudio/r-session-complete)
- [An overview of the job launcher](https://solutions.rstudio.com/launcher/overview/)

# Dev Workflow

## Build Pipeline

- All branches / PRs are built on Jenkins
- Only `master` pushes to the ECR repository

## Run tests locally

- Install [`dgoss`](https://github.com/aelsabbahy/goss/tree/master/extras/dgoss)
- Run `make test` 
- To edit tests interactively run `make edit`
- **NOTE**: this requires that you have built (or pulled) the images locally

## Excluding Packages

Some packages are ok to fail... and we have more failures for older R versions...
- Add packages that are OK failing to `pkg_failing.txt`
- Run `make vars` to regenerate the `goss_vars.yaml`
- Ultimately, we need to take some additional passes at these to find out why they are failing
