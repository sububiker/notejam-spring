timestamps {
    timeout(time: 20, unit: 'MINUTES') {  
        node() {
            stage('Build, test and package') {
                def version = sh(script: 'git describe --tags', returnStdout: true).trim()
                sh 'mvn package'
                step([$class: 'JUnitResultArchiver', testResults: '**/target/surefire-reports/TEST-*.xml'])
                def image = docker.build("andrey9kin/notejam-spring:${version}", '.')
                docker.withRegistry('https://registry.hub.docker.com', 'andrey9kin') {
                    image.push(version)
                }
            }
        }
    }
}
