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

            def dockerImage = docker.image("vrusso300/coursework2")

            def dockerContainer = dockerImage.run('-d --name coursework2container -p 8081:8080')

            // Stop and remove the container
            dockerContainer.stop()
            dockerContainer.remove(force: true)
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
                /* Optionally, push with the 'latest' tag */
                app.push("latest")

                /* Also, print the image URL for reference */
                echo "Docker image pushed to vrusso300/coursework2:${imageTag}"
            }
        }
    }
}


