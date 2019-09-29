  pipeline {
    agent {
        node 'jenkins_slave_stag'
    }
    stages {
        stage('checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/ganez-bhoosal/spring-petclinic.git'
            }
        }
        stage('dockerbuild') {
            steps {
                script {
                  sh 'export PATH=/usr/local/bin/:$PATH; docker build . -t petclinic:${BUILD_NUMBER}'    
            }
          }
        }
        stage('dockerdeploy') {
            steps {
                script {
                  sh 'set +x; $(aws ecr get-login --no-include-email --region us-east-1)'
                  sh 'docker tag petclinic:latest 111170519921.dkr.ecr.us-east-1.amazonaws.com/petclinic:latest'
                  sh 'docker tag petclinic:latest 111170519921.dkr.ecr.us-east-1.amazonaws.com/petclinic:${BUILD_NUMBER}'
                  sh 'docker push 111170519921.dkr.ecr.us-east-1.amazonaws.com/petclinic:latest'
                  sh 'docker push 111170519921.dkr.ecr.us-east-1.amazonaws.com/petclinic:${BUILD_NUMBER}'
            }
          }
        }
    }
}
