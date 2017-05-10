timestamps {
    timeout(time: 20, unit: 'MINUTES') {  
        node() {
            stage('Build, test and package') {
                def version = sh(script: 'git describe --tags', returnStdout: true).trim()
                sh 'mvn package'
                step([$class: 'JUnitResultArchiver', testResults: '**/target/surefire-reports/TEST-*.xml'])
                def image = docker.build("andrey9kin/notejam-spring:${version}", '.')
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
