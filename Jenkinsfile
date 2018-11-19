pipeline {
    agent any

    environment {
        USER_NAME = "prashant"
        SERVICE_NAME = "odin"
        AWS_REGION = "us-east-1"
        REPO_NAME = "${USER_NAME}/${SERVICE_NAME}""
        ECR_REPO_URI = "738035286324.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPO_NAME}"
    }

    triggers {
     pollSCM('H * * * *')
    }

    stage("build-and-test") {
        steps {
            sh 'mvn clean install'
        }
    }

    stage ('build-docker-image-and-push-to-registry') {
        steps {
            script {
                GIT_SHA=sh returnStdout: true, script: 'git rev-parse HEAD'
                buildDockerImageAndPushToECR(GIT_SHA, REPO_NAME)
            }
        }
    }
}

def buildDockerImageAndPushToECR(imageTag, repoName, region, repoUri) {
    ensureDockerRepoExists(repoName, region)
    sh """
        docker build . -t \${repoName}:\${imageTag};
        docker tag \${repoName}:\${imageTag} \${repoUri}:\${imageTag};
        eval "\$(aws ecr get-login --no-include-email --region eu-west-1)";
        docker push \${repoUri}:\${imageTag}
    """
}


def ensureDockerRepoExists(repoName, region) {
    script {
        sh "\$(aws ecr get-login --no-include-email --region ${region})"
        try {
            sh "echo 'Ensure that ECR repository exists: ${repoName}'"
            sh "aws ecr create-repository --repository-name ${repoName} --region ${region}"
        } catch (e) {
            /* ignore if repository already exists. */
        }
    }
}