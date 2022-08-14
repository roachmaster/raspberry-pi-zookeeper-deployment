node {

    stage("Clone"){
        git 'git@github.com:roachmaster/raspberry-pi-zookeeper-deployment.git'
    }

    stage("Docker Build"){
        withCredentials([usernamePassword(credentialsId: '87e61f11-079d-4052-b083-ea5859f0f85b', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
            def dockerVersion = "2.0.0-SNAPSHOT"
            dockerBuild(dockerName:"${DOCKER_USERNAME}/pi-zookeeper:${dockerVersion}",
                        dockerOpt:"",
                        DOCKER_PASSWORD: "${DOCKER_PASSWORD}",
                        DOCKER_USERNAME:"${DOCKER_USERNAME}")
        }
    }

    stage("Create Zoo keeper"){
        sh "kubectl delete --ignore-not-found=true statefulset.apps/zk  service/zk-cs service/zk-hs"
        sh "kubectl apply -f k3s/zookeeper.yml"
    }
}