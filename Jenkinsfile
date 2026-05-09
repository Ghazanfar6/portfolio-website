pipeline {

    agent any

    environment {
        IMAGE_NAME = 'ghazanfar6/portfolioweb-app'
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {

            steps {
                git branch: 'main',
                url: 'https://github.com/Ghazanfar6/portfolio-website.git'
            }
        }

        stage('Build Docker Image') {

            steps {
                sh 'docker build -t $IMAGE_NAME:$IMAGE_TAG -t $IMAGE_NAME:latest .'
            }
        }

        stage('Test Docker Image') {

            steps {

                sh '''
                docker rm -f portfolio-test || true

                docker run -d -p 8081:8081 --name portfolio-test $IMAGE_NAME:$IMAGE_TAG

                sleep 5

                curl -f http://localhost:8081

                docker rm -f portfolio-test
                '''
            }
        }

        stage('Push Docker Image') {

            steps {

                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {

                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin

                    docker push $IMAGE_NAME:$IMAGE_TAG

                    docker push $IMAGE_NAME:latest
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {

            steps {

                sh '''
                kubectl apply -f k8s/deployment.yaml

                kubectl apply -f k8s/service.yaml

                kubectl rollout status deployment/portfolio-app

                kubectl get pods

                kubectl get services
                '''
            }
        }
    }
}
