pipeline {
    agent any
    stages {
        stage('Build, test and package') {
            steps {
                sh 'mvn package'
                sh 'docker build -t andrey9kin/notejam-spring:$(git describe --tags) .'
                step([$class: 'JUnitResultArchiver', testResults: '**/target/surefire-reports/TEST-*.xml'])
            }
        }
        stage('Push to Docker Hub') {
            when {
                branch 'master'
            }
            steps {
                echo 'Push to Docker hub'
            }
        }
        stage('Deploy to stage') {
            when {
                branch 'master'
            }
            steps {
                echo 'staging'
            }
        }
    }
}
