 pipeline {
    agent {
        node 'Jenkins_slave5'
    }
    tools {
        maven 'mymaven'
        }
    stages {
        stage('checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/puspakhanal70726/spring-petclinic.git'
            }
        }
        stage('package') {
            steps {
                sh 'mvn install'
            }
        }
         stage('Deploy') {
            steps {
                sh 'export AWS_DEFAULT_PROFILE=puspa; pwd; aws s3 cp ${WORKSPACE}/target/gs-spring-boot-0.1.0.jar s3://oneline-hub/'
            }   
        }
    }
}


