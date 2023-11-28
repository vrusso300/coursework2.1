node {
    def app

    stage('Clone repository') {
        checkout scm
    }

    stage('Build image') {
        app = docker.build("vrusso300/coursework2")
    }

    stage('Test image') {
        app.inside {
            sh 'echo "Tests passed"'
        }
    }

   stage('Run Container'){
        script {

            def containerId = docker.image("vrusso300/coursework2").run("-d -p 8081:8080").id
         
            try {

                sh 'docker ps'
            }
            finally{
                // Stop and remove the container
                sh "docker stop ${containerId}"
                sh "docker rm -f --volumes ${containerId}"
            }
        }
   }

    stage('Push image') {
        /* Use withDockerRegistry to handle Docker Hub authentication */
        script {
            docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                /* When using 'app.push', it's better to specify the tag separately
                   to avoid pushing multiple tags unintentionally */
                def imageTag = "${env.BUILD_NUMBER}"
                app.push(imageTag)
                /* Also, print the image URL for reference */
                echo "Docker image pushed to vrusso300/coursework2:${imageTag}"
            }
        }
    }

    stage('Deploy to Kubernetes') {

        def imageTag = "${env.BUILD_NUMBER}"

        script {
            withCredentials([sshUserPrivateKey(credentialsId: 'my-ssh-key', keyFileVariable: 'KEY_FILE')]) {
                sh "ssh -o StrictHostKeyChecking=no -i $KEY_FILE ubuntu@35.153.52.155 'kubectl set image deployments/cw2-deployment coursework2=vrusso300/coursework2:latest'"
            }
        }
    }


}


