#!groovy

// ideas for future data-driven approach
// https://stackoverflow.com/questions/42770775/how-to-define-and-iterate-over-map-in-jenkinsfile

// NOTE: Named parameters _is_ a thing
// http://docs.groovy-lang.org/latest/html/documentation/#_named_parameters


// only push images from main
pushImage = (env.BRANCH_NAME == 'main')

// buildImage hides most of the pullBuildPush details from callers.
def buildImage(def tag, def rVersions, def defaultR, def pythonVersions, def defaultPython) {
    
    // Note that the image will have additional versions of R and Python installed
    // other than those defined in rVersions and pythonVersions. See the README
    // for more details.
    print("Bulding R versions: ${rVersions}")
    print("Bulding Python versions: ${pythonVersions}")

    node('docker') {
        checkout scm
        def imageName = 'sol-eng-demo-server'
        def now = new Date().format("yyyyMMdd", TimeZone.getTimeZone('UTC'))
        def finalTag = tag + "-" + now

        def image = pullBuildPush(
            image_name: imageName,
            image_tag: finalTag,
            // can use this to invalidate the cache if needed
            // cache_tag: 'none',
            dockerfile: 'Dockerfile',
            build_args: "--build-arg R_VERSIONS='${rVersions}' --build-arg R_DEFAULT_VERSION=${defaultR} --build-arg PYTHON_VERSIONS='${pythonVersions}' --build-arg PYTHON_DEFAULT_VERSION=${defaultPython}",
            build_arg_jenkins_uid: 'JENKINS_UID',
            build_arg_jenkins_gid: 'JENKINS_GID',
            registry_url: 'https://075258722956.dkr.ecr.us-east-1.amazonaws.com',
            push: pushImage
        )

        return image
    }

}

ansiColor('xterm') {
    stage('setup') {
        node('docker') {
            checkout scm
        }
    }
    stage('build') {
        parallel '2023.09.1-old-r-and-python': {
            def image = buildImage("2023.09.1-past-r-and-python", "3.5.3 3.6.3", "4.2.3", "3.7.16", "3.9.14")
            print "Finished 2023.09.1-old-r-and-python"
        },
        '2023.09.1-default': {
            def image = buildImage("2023.09.1-default", "4.0.5 4.1.3", "4.2.3", "3.10.11", "3.10.11")
            print "Finished 2023.09.1-default"
        }
    }
    stage('finish') {
        node('docker') {
            print "Finished pipeline"
        }
    }
}
