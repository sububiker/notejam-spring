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
                dir('/k8s') {
                    sh '. ./setup_kubectl.sh'
                }
                if (!isDeployed('stage')) {
                    initialDeploy('stage')
                }
                sh "kubectl --namespace=stage set image deployment/frontend springboot-app=andrey9kin/notejam-spring:${version}"
            }
        }
    }
}

def isDeployed(def env) {
    echo 'Check if deployments already created'
    sh "kubectl --namespace=${env} get deployments 2> deployments"
    def deployments = readFile('deployments').trim()
    echo "Deployments: ${deployments}"
    if (deployments.equalsIgnoreCase('No resources found.')) {
        return False
    }
    return True
}

def initialDeploy(def env) {
    echo 'Create deployments and services'
    sh "kubectl --namespace=${env} create -f ./k8s/secrets.yaml"
    sh "kubectl --namespace=${env} create -f ./k8s/postgres-deployment.yaml"
    sh "kubectl --namespace=${env} create -f ./k8s/postgres-service.yaml"
    sh "kubectl --namespace=${env} create -f ./k8s/frontend-deployment.yaml"
    sh "kubectl --namespace=${env} create -f ./k8s/frontend-service.yaml"
}
