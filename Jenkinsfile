def version = null
def image = null

timestamps {
    timeout(time: 20, unit: 'MINUTES') {  
        node() {
            stage('Checkout') {
                checkout scm
            }
            stage('Build, test and package') {
                version = sh(script: 'git describe --tags', returnStdout: true).trim()
                sh 'mvn package'
                step([$class: 'JUnitResultArchiver', testResults: '**/target/surefire-reports/TEST-*.xml'])
                image = docker.build("andrey9kin/notejam-spring:${version}", '.')
            }
            stage('Push to docker hub') {
                docker.withRegistry('https://registry.hub.docker.com', 'andrey9kin') {
                    image.push(version)
                }
            }
            stage('Deploy to staging') {
                echo 'Deploy!'
            }
        }
    }
}
