#!groovy

// ideas for future data-driven approach
// https://stackoverflow.com/questions/42770775/how-to-define-and-iterate-over-map-in-jenkinsfile

// NOTE: Named parameters _is_ a thing
// http://docs.groovy-lang.org/latest/html/documentation/#_named_parameters


// only push images from main
pushImage = (env.BRANCH_NAME == 'main')

// buildImage hides most of the pullBuildPush details from callers.
def buildImage(Map args=null, def rVersions, def pythonVersions, def gossVars='goss_vars_basic.yaml') {
    
    print("Bulding R versions: ${rVersions}")
    print("Bulding Python versions: ${pythonVersions}")

    node('docker') {
        checkout scm
    
        def image = pullBuildPush(
            image_name: 'pwb-session',
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
        
        def imageName = image.imageName()

        sh """
        # See https://github.com/aelsabbahy/goss/releases for release versions
        curl -L https://github.com/aelsabbahy/goss/releases/download/v0.3.8/goss-linux-amd64 -o ./goss
        chmod +rx ./goss

        # (optional) dgoss docker wrapper (use 'master' for latest version)
        curl -L https://raw.githubusercontent.com/aelsabbahy/goss/v0.3.8/extras/dgoss/dgoss -o ./dgoss
        chmod +rx ./dgoss

        GOSS_VARS=${gossVars} GOSS_PATH=./goss ./dgoss run -it -e R_VERSIONS=${rVersions} ${imageName}
        """
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
        parallel '2023.03-jammy': {
            def image = buildImage(
                rVersions: "", 
                pythonVersions: "", 
                latest: true, 
                dockerfile: '.Dockerfile.ubuntu2204',
                tag: "pwb-202303-jammy", 
                gossVars: 'goss_vars.yaml'
            )
            print "2023.03-jammy"
        }
    }
    stage('finish') {
        node('docker') {
            print "Finished pipeline"
        }
    }
}
