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

String buildRRepo(def pointer='latest', def repo='all',  def host='colorado.rstudio.com/rspm') {
  def value = "https://${host}/${repo}/__linux__/bionic/${pointer}"
  return value
}

// only push images from master
pushImage = (env.BRANCH_NAME == 'master')

// buildImage hides most of the pullBuildPush details from callers.
def buildImage(Map args=null, def rspVersion, def rVersion, def rRepo, def gossVars='goss_vars_basic.yaml') {
    def minorRVersion = minorVersion(rVersion)
    print "Building R version: ${rVersion}, minor version: ${minorRVersion}"
    print "Using R Repository: ${rRepo}"
    node('docker') {
    checkout scm

    if (!args) {
      // create dummy map so lookups do not fail
      args = [dummy: true]
    }

    // alt args
    def altArgs = ''
    if (args.rVersionAlt) {
      altArgs = "${altArgs} --build-arg R_VERSION_ALT=${args.rVersionAlt}"
    }
    if (args.pyVersion) {
      altArgs = "${altArgs} --build-arg PYTHON_VERSION=${args.pyVersion}"
    }
    if (args.pyVersionAlt) {
      altArgs = "${altArgs} --build-arg PYTHON_VERSION_ALT=${args.pyVersionAlt}"
    }
    if (args.rRepoAlt) {
      altArgs = "${altArgs} --build-arg R_REPO_ALT=${args.rRepoAlt}"
    }
    print "Using Alternate Arguments: ${altArgs}"

    if (!args.tag) {
      tag = "${rspVersion}-${minorRVersion}"
    } else {
      tag = args.tag
    }
    print "Building tag: ${tag}"

    if (!args.dockerfile) {
      dockerfile = './Dockerfile'
    } else {
      dockerfile = args.dockerfile
    }

    if (!args.latest) {
      latest = false
    } else {
      latest = args.latest
    }

    def image = pullBuildPush(
          image_name: 'sol-eng-demo-server',
          image_tag: tag,
          // can use this to invalidate the cache if needed
	  // cache_tag: 'none',
          latest_tag: latest,
          dockerfile: dockerfile,
          build_args: "--build-arg RSP_VERSION=${rspVersion} --build-arg R_VERSION=${rVersion} --build-arg R_REPO=${rRepo} ${altArgs}",
          build_arg_jenkins_uid: 'JENKINS_UID',
          build_arg_jenkins_gid: 'JENKINS_GID',
          registry_url: 'https://075258722956.dkr.ecr.us-east-1.amazonaws.com',
	  push: pushImage
        )
    def imageName = image.imageName()
    sh """
    # See https://github.com/aelsabbahy/goss/releases for release versions
    curl -L https://github.com/aelsabbahy/goss/releases/download/v0.3.8/goss-linux-amd64 -o ./goss
    chmod +rx ./goss

    # (optional) dgoss docker wrapper (use 'master' for latest version)
    curl -L https://raw.githubusercontent.com/aelsabbahy/goss/v0.3.8/extras/dgoss/dgoss -o ./dgoss
    chmod +rx ./dgoss

    GOSS_VARS=${gossVars} GOSS_PATH=./goss ./dgoss run -it -e R_VERSION=${rVersion} ${imageName}
    """
    return image
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
    parallel 'apache-proxy': {
      node('docker') {
        checkout scm
        def apache_image = pullBuildPush(
              image_name: 'apache-proxy',
              image_tag: "1.1-${BUILD_NUMBER}",
              // can use this to invalidate the cache if needed
              // cache_tag: 'none',
              latest_tag: true,
              dockerfile: './helper/apache-proxy/Dockerfile',
              docker_context: './helper/apache-proxy/',
              registry_url: 'https://075258722956.dkr.ecr.us-east-1.amazonaws.com',
              push: pushImage
            )
        print "Finished apache-proxy"
      }
    },
    'connect': {
      node('docker') {
        checkout scm
        def apache_image = pullBuildPush(
              image_name: 'connect',
              image_tag: '1.8.6',
              // can use this to invalidate the cache if needed
              // cache_tag: 'none',
              latest_tag: true,
              dockerfile: './helper/connect/Dockerfile',
              docker_context: './helper/connect/',
              registry_url: 'https://075258722956.dkr.ecr.us-east-1.amazonaws.com',
              push: pushImage
            )
        print "Finished connect"
      }
    },
    '4.0': {
      def image = buildImage(RSPVersion, '4.0.2', buildRRepo('4047'))
      print "Finished 4.0"
    },
    '3.6': {
      def image = buildImage(RSPVersion, '3.6.1', buildRRepo('1654'))
      print "Finished 3.6"
    },
    '3.5': {
      def image = buildImage(RSPVersion, '3.5.3', buildRRepo('1408'))
      print "Finished 3.5"
    },
    '3.4': {
      def image = buildImage(RSPVersion, '3.4.4', buildRRepo('324'))
      print "Finished 3.4"
    },
    '202006': {
      def image = buildImage(RSPVersion, '4.0.2', buildRRepo('4047'), latest: true, dockerfile: './Dockerfile_multi', rVersionAlt: '3.6.2', pyVersion: '3.7.3', pyVersionAlt: '3.6.7', rRepoAlt: buildRRepo('2603'), tag: "${RSPVersion}-202006", gossVars: 'goss_vars.yaml')
      print "Finished 202006"
    }
  }
  stage('finish') {
    node('docker') {
      print "Finished pipeline"
    }
  }
}
