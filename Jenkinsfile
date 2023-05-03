#!groovy

// ideas for future data-driven approach
// https://stackoverflow.com/questions/42770775/how-to-define-and-iterate-over-map-in-jenkinsfile

// NOTE: Named parameters _is_ a thing
// http://docs.groovy-lang.org/latest/html/documentation/#_named_parameters


// only push images from main
pushImage = (env.BRANCH_NAME == 'main')

// buildImage hides most of the pullBuildPush details from callers.
def buildImage(def tag, def rVersions, def pythonVersions, def latest) {
    
    print("Bulding R versions: ${rVersions}")
    print("Bulding Python versions: ${pythonVersions}")

    node('docker') {
        checkout scm
        def imageName = 'pwb-session'
        
        def image = pullBuildPush(
            image_name: imageName,
            image_tag: tag,
            // can use this to invalidate the cache if needed
            // cache_tag: 'none',
            latest_tag: latest,
            dockerfile: 'Dockerfile',
            build_args: "--build-arg R_VERSIONS=${rVersions} --build-arg PYTHON_VERSIONS=${pythonVersions}",
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
        parallel '2023.03.0-default': {
            // This image will have Python:
            // - 3.8.15 (included in rstudio/r-session-complete:jammy-2023.03.0--fa5bcba)
            // - 3.9.14 (included in rstudio/r-session-complete:jammy-2023.03.0--fa5bcba)
            // - 3.10.11
            // This image will have R:
            // - 4.0.5
            // - 4.1.3 (included in rstudio/r-session-complete:jammy-2023.03.0--fa5bcba)
            // - 4.2.3 (included in rstudio/r-session-complete:jammy-2023.03.0--fa5bcba)
            def image = buildImage("2023.03.0-default", "4.0.5", "3.10.11", true)
            print "Finished 2023.03.0-default"
        },
        '2023.03.0-old-r-and-python': {
            // This image will have Python:
            // - 3.7.16
            // - 3.8.15 (included in rstudio/r-session-complete:jammy-2023.03.0--fa5bcba)
            // - 3.9.14 (included in rstudio/r-session-complete:jammy-2023.03.0--fa5bcba)
            // This image will have R:
            // - 3.5.3
            // - 3.6.3
            // - 4.1.3 (included in rstudio/r-session-complete:jammy-2023.03.0--fa5bcba)
            // - 4.2.3 (included in rstudio/r-session-complete:jammy-2023.03.0--fa5bcba)
            def image = buildImage("2023.03.0-old-r-and-python", "3.5.3 3.6.3", "3.7.16", true)
            print "Finished 2023.03.0-old-r-and-python"
        }
    }
    stage('finish') {
        node('docker') {
            print "Finished pipeline"
        }
    }
}
