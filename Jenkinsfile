#!groovy

// ideas for future data-driven approach
// https://stackoverflow.com/questions/42770775/how-to-define-and-iterate-over-map-in-jenkinsfile

def minorVersion(def version) {
  // versionPattern captures MAJOR.MINOR.SUBMINOR and ignores follow-on characters
  def versionPattern = ~/^(\d+)\.(\d+)\.(\d+).*$/

  def val = version.replaceFirst(versionPattern) {
    "${it[1]}.${it[2]}"
  }
  return val
}

def buildRRepo(def tag='latest') {
  return "https://demo.rstudiopm.com/all/__linux__/bionic/${tag}"
}

// buildImage hides most of the pullBuildPush details from callers.
def buildImage(def rspVersion, def rVersion, def rRepo=buildRRepo(), def latest=false) {
    def minorRVersion = minorVersion(rVersion)
    print "Building R version ${rVersion}"
    print "Building R minor version ${minorRVersion}"
    def image = withAWS(role: 'build', roleAccount: '075258722956') {
        pullBuildPush(
          image_name: 'sol-eng-demo-server',
          image_tag: "${rspVersion}-${minorRVersion}",
          cache_tag: 'latest',
          latest_tag: latest,
          dockerfile: "./${minorRVersion}/Dockerfile",
          build_args: "--build-arg RSP_VERSION=${rspVersion} --build-arg R_VERSION=${rVersion} --build-arg R_REPO=${rRepo}",
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
	    buildImage(RSPVersion, '3.6.1', rRepo=buildRRepo(), latest = true)
	  }
        }
      }
    }
}
