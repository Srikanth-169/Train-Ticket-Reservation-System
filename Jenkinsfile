pipeline {
    agent any

    tools {
        jdk 'JDK17'
        maven 'MVN3'
    }

    environment {
        SONARQUBE_SCANNER = 'sq' // SonarQube scanner name from Jenkins
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
        AWS_REGION = 'ap-south-1'
        AWS-CREDENTIALS = "sss"
    }

    stages {
        stage('GIT CHECKOUT') {
            steps {
                checkout scmGit(
                    branches: [[name: '*/master']],
                    userRemoteConfigs: [[url: 'https://github.com/Srikanth-169/Train-Ticket-Reservation-System.git']]
                )
            }
        }

        stage('CHECK ERROR') {
            steps { sh "mvn validate" }
        }

        stage('CHECK COMPILE') {
            steps { sh "mvn compile" }
        }

        stage('CHECK TEST') {
            steps { sh "mvn test" }
        }

        stage('CHECK PACKAGE') {
            steps { sh "mvn package -DskipTests" }
        }

         stage('SonarQube Analysis') {
            steps {
                
                withSonarQubeEnv('sri') {  
                    sh 'mvn clean verify sonar:sonar'
                }
            }
        }

       stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t srikanth169/train-ticket:v1 .'
                }
            }
        }

        stage('Push to DockerHub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    sh "echo $PASS | docker login -u $USER --password-stdin"
                    sh "docker push srikanth169/train-ticket:v1"
                }
            }
        }


        stage('Deploy to Kubernetes') {
            steps {
                sh """
                  kubectl apply -f deployment.yml
                  kubectl apply -f ingress.yaml || true
                """
            }
        }
    }
}
