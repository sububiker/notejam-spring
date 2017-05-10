pipeline {
    agent any
    stages {
        stage('Build and test') {
            steps {
                sh 'mvn package'
                step([$class: 'JUnitResultArchiver', testResults: '**/target/surefire-reports/TEST-*.xml'])
            }
        }
        stage('Package') {
            when {
                branch 'production'
            }
            steps {
                echo 'Deploying'
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
