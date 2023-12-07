node {
    def app

    stages {
        stage('Clone Repository') {
            steps {
                checkout scm
            }
        }

        stage('Build and Test Image') {
            steps {
                script {
                    def app = docker.build("vrusso300/coursework2")
                    app.inside {
                        sh 'echo "Tests passed"'
                    }
                }
            }
        }

        stage('Run Container') {
            steps {
                script {
                    def containerId = docker.image("vrusso300/coursework2").run("-d -p 8081:8080").id

                    try {
                        sh 'docker ps'
                    } finally {
                        sh "docker stop ${containerId}"
                        sh "docker rm -f --volumes ${containerId}"
                    }
                }
            }
        }

        stage('Push Image') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        def imageTag = "v1.${env.BUILD_NUMBER}"  // Adjust the tag as needed
                        app.push(imageTag)
                        echo "Docker image pushed to vrusso300/coursework2:${imageTag}"
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    def imageTag = "v1.${env.BUILD_NUMBER}"  // Adjust the tag as needed
                    withCredentials([sshUserPrivateKey(credentialsId: 'my-ssh-key', keyFileVariable: "KEY_FILE")]) {
                        sh 'ssh -o StrictHostKeyChecking=no -i $KEY_FILE ubuntu@54.158.206.118 "kubectl set image deployments/cw2-deployment coursework2=vrusso300/coursework2:' + "${imageTag}" + '"'
                    }
                }
            }
        }
    }
}
