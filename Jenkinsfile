#!groovy

// buildImageTag takes the kind of Docker image (usually OS distribution)
//
def buildImageTag(imageKind) {
    return "${imageKind}-${RSPVersion}"
}

// buildImage hides most of the pullBuildPush details from callers.
//
// imageKind is "kind" of Docker image (usually OS distribution).
//
// dockerContext is the path to the directory to use as the Docker context
// when building the image. This must be the directory containing the
// Dockerfile to build.
def buildImage(def imageKind, def dockerContext) {
    def image = pullBuildPush(
        image_name: 'sol-eng-demo-server',
        image_tag: buildImageTag(imageKind),
        docker_context: dockerContext,
        build_arg_jenkins_uid: 'JENKINS_UID',
        build_arg_jenkins_gid: 'JENKINS_GID',
        push: pushImage
    )
    return image
}

pipeline {
  agent none
  environment {
    HOME = "."
  }
  options {
    ansiColor('xterm')
  }
  stage('setup') {
    node('docker') {
          checkout scm
          RSPVersion = readFile("rsp-version.txt").trim()
    }
  }
  //stage('build images') {
  //  agent { label 'docker' }
  //  steps {
  //    //withAWS(role: 'build', roleAccount: '954555569365') {
  //    //    pullBuildPush(
  //    //      image_name: 'lucid-auth-saml',
  //    //      image_tag: image_tag,
  //    //      latest_tag: true,
  //    //      cache_tag: 'latest',
  //    //      dockerfile: './Dockerfile',
  //    //      registry_url: 'https://954555569365.dkr.ecr.us-east-1.amazonaws.com'
  //    //    )
  //    //}
  //  }
  //}
}
