# sol-eng-demo-server

This repository contains Workbench session images deployed to the Solutions Engineering Demo server (lovingly known as "Colorado").

## Description

Posit uses these images for our [Posit Workbench demo environment ("Colorado")](https://colorado.posit.co). This image builds off of the [r-session-complete](https://github.com/rstudio/rstudio-docker-products/tree/dev/r-session-complete) image. It serves as a great example to get started with building your own Posit Workbench session images.

The sol-eng-demo-server images are built from [r-session-complete](https://github.com/rstudio/rstudio-docker-products/tree/dev/r-session-complete). Specifically, the image is based on `rstudio/r-session-complete:jammy-2023.03.0--fa5bcba`. The `r-session-complete` includes most of the components we need for our Workbench sessions, including:

- Workbench session components
- System dependencies required to build and install most R packages
- The [Posit Professional Database Drivers](https://docs.posit.co/pro-drivers/)
- R version 4.1.3
- R version 4.2.3
- Python version 3.8.15
- Python version 3.9.14

The base `r-session-complete` is extended by adding additional R and Python versions and system dependencies requested by Colorado users. See the [Dockerfile](./Dockerfile) for more details.

These images are stored in AWS ECR; they are not accessible on DockerHub.

## Dev Workflow

### Build Pipeline

- A push to any branch will trigger a build in Jenkins.
- Only pushes to the `main` will trigger pushing a new image to the ECR repository.

### Local development

Before triggering a new Jenkins build, verify that you can build and test the images locally. This repository uses [justfile](https://github.com/casey/just) to run common commands.

Build the image locally:

```bash
just build
```
Run tests:

```bash
just test
```
