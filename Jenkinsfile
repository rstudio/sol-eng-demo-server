#!groovy

// ideas for future data-driven approach
// https://stackoverflow.com/questions/42770775/how-to-define-and-iterate-over-map-in-jenkinsfile

// NOTE: Named parameters _is_ a thing
// http://docs.groovy-lang.org/latest/html/documentation/#_named_parameters

def minorVersion(def version) {
  // versionPattern captures MAJOR.MINOR.SUBMINOR and ignores follow-on characters
  def versionPattern = ~/^(\d+)\.(\d+)\.(\d+).*$/

  def val = version.replaceFirst(versionPattern) {
    "${it[1]}.${it[2]}"
  }
  return val
}

String buildRRepo(def pointer='latest', def repo='all',  def host='demo') {
  def value = "https://${host}.rstudiopm.com/${repo}/__linux__/bionic/${pointer}"
  return value
}

// buildImage hides most of the pullBuildPush details from callers.
def buildImage(def rspVersion, def rVersion, def rRepo, def latest=false) {
    def minorRVersion = minorVersion(rVersion)
    print "Building R version: ${rVersion}, minor version: ${minorRVersion}"
    print "Using R Repository: ${rRepo}"
    node('docker') {
    checkout scm
    def image = pullBuildPush(
          image_name: 'sol-eng-demo-server',
          image_tag: "${rspVersion}-${minorRVersion}",
	  //cache_tag: 'none',
          latest_tag: latest,
          dockerfile: "./3.6/Dockerfile",
          build_args: "--build-arg RSP_VERSION=${rspVersion} --build-arg R_VERSION=${rVersion} --build-arg R_REPO=${rRepo}",
          build_arg_jenkins_uid: 'JENKINS_UID',
          build_arg_jenkins_gid: 'JENKINS_GID',
          registry_url: 'https://075258722956.dkr.ecr.us-east-1.amazonaws.com'
        )
    }
}

ansiColor('xterm') {
  stage('setup') {
    node('docker') {
      checkout scm
      RSPVersion = readFile("rsp-version.txt").trim()
      print "Building RSP version: ${RSPVersion}"
    }
  }
  stage('build') {
    parallel '3.6': {
      //buildImage(RSPVersion, '3.6.1', buildRRepo('1654'), true)
      buildImage(RSPVersion, '3.6.1', buildRRepo('688', 'cran', 'cluster'), true)
      print "Finished 3.6"
    },
    '3.5': {
      //buildImage(RSPVersion, '3.5.3', buildRRepo('1408'))
      buildImage(RSPVersion, '3.5.3', buildRRepo('624', 'cran', 'cluster'))
      print "Finished 3.5"
    },
    '3.4': {
      //buildImage(RSPVersion, '3.4.4', buildRRepo('324'))
      buildImage(RSPVersion, '3.4.4', buildRRepo('51', 'cran', 'cluster'))
      print "Finished 3.4"
    },
    '3.3': {
      //buildImage(RSPVersion, '3.3.3', buildRRepo('324'))
      buildImage(RSPVersion, '3.3.3', buildRRepo('3', 'cran', 'cluster'))
      print "Finished 3.3"
    }
  }
  stage('finish') {
    node('docker') {
      print "Finished pipeline"
    }
  }
}
