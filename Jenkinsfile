#!groovy

// ideas for future data-driven approach
// https://stackoverflow.com/questions/42770775/how-to-define-and-iterate-over-map-in-jenkinsfile

// NOTE: Named parameters _is_ a thing
// http://docs.groovy-lang.org/latest/html/documentation/#_named_parameters


// only push images from main
pushImage = (env.BRANCH_NAME == 'main')

// buildImage hides most of the pullBuildPush details from callers.
def buildImage(def tag, def rVersions, def pythonVersions, def latest, def gossVars) {
    
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
            dockerfile: 'Dockerfile.ubuntu2204',
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
        parallel 202303jammy: {
            def image = buildImage(tag: "202303-jammy", rVersions: "3.6.3",  pythonVersions: "3.11.3", latest: true)
            print "Finished 2023.03-jammy"
        },
        202303jammy2: {
            def image = buildImage(tag: "202303-jammy", rVersions: "4.0.5",  pythonVersions: "3.11.3", latest: true)
            print "Finished 2023.03-jammy"
        }
    }
    stage('finish') {
        node('docker') {
            print "Finished pipeline"
        }
    }
}
