#!groovy

// buildImageTag takes the kind of Docker image (usually OS distribution)
//
def buildImageTag(imageKind) {
    return "${imageKind}-${RSPVersion}"
}

// buildImage hides most of the pullBuildPush details from callers.
//
// imageKind is "kind" of Docker image (usually OS distribution).  //
// dockerContext is the path to the directory to use as the Docker context
// when building the image. This must be the directory containing the
// Dockerfile to build.
def buildImage(def rspVersion, def rVersion) {
    def image = withAWS(role: 'build', roleAccount: '075258722956') {
        pullBuildPush(
          image_name: 'sol-eng-demo-server',
          image_tag: "${rspVersion}-${rVersion}",
          latest_tag: false,
          dockerfile: "./${rVersion}/Dockerfile",
          build_args: "--build-arg RSP_VERSION=${rspVersion}",
          build_arg_jenkins_uid: 'JENKINS_UID',
          build_arg_jenkins_gid: 'JENKINS_GID',
          registry_url: 'https://075258722956.dkr.ecr.us-east-1.amazonaws.com'
        )
    }
    return image
}

node('docker') {
    timestamps {
      ansiColor('xterm') {
        stage('setup') {
          checkout scm
          RSPVersion = readFile("rsp-version.txt").trim()
        }
        stage('build') {
	  parallel '3.6': {
	    buildImage(RSPVersion, '3.6')
	  }
        }
      }
    }
}
