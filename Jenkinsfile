pipeline {
    agent any

    tools {
        jdk 'JDK17'
        maven 'MVN3'
    }

    environment {
        SONARQUBE_SCANNER = 'sq' // SonarQube scanner name from Jenkins
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
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
                    sh "mvn sonar:sonar -Dsonar.projectKey=java-app -Dsonar.host.url=http://<SONARQUBE_URL> -Dsonar.login=<SONAR_TOKEN>"
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh """
                      docker build -t srikanth169/java-app:latest .
                      echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                      docker push your-dockerhub-username/java-app:latest
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh """
                  kubectl apply -f k8s/deployment.yml
                  kubectl apply -f k8s/ingress.yaml || true
                """
            }
        }
    }
}
