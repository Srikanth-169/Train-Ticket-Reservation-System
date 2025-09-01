pipeline {
    agent any

    stages {
        stage('GIT CHECKOUT') {
            steps {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'pic', url: 'https://github.com/vijay254452/Java-Projects-Collections.git']])
            }
        }
     stage('CHECK ERROR') {
         steps {
             sh "mvn validate"
         }
    }
    stage('CHECK COMPILE') {
         steps {
             sh "mvn compile"
         }
        } 
        stage('CHECK TEST') {
         steps {
             sh "mvn test"
         }
        }
        stage('CHECK PACKAGE') {
         steps {
             sh "mvn package"
         }
        }
  }
}
