pipeline {
    agent any 
    stages {
        stage('Build da imagem docker'){
            steps {
                sh 'docker build -t devops/app .'
            }
        }
        stage('Subir Docker Compose - Redis e APP'){
            steps {
                sh 'docker-compose up --build -d'
            }
        }
        stage('Sleep para subida de containers'){
            steps{
                sh 'sleep 10'
            }
        }
        stage('Validacao Sonarqube'){
            steps{
                script{
                    scannerHome = tool 'sonar-scanner';
                }
                withSonarQubeEnv('sonar-server'){
                    sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=redis-app -Dsonar.sources=. -Dsonar.host.url=${env.SONAR_HOST_URL} -Dsonar.login=${env.SONAR_AUTH_TOKEN}"
                }
            }
        }
        stage('Quality Gate'){
            steps{
                waitForQualityGate abortPipeline: true
            }
        }
        stage('Teste da aplicação'){
            steps{
                sh 'chmod +x teste-app.sh'
                sh './teste-app.sh'
            }
        }
        stage('Shutdown dos containers de teste'){
            steps{
                sh 'docker-compose down'
            }
        }
        stage('Upload Docker Image'){
            steps{
                script{
                    withCredentials([usernamePassword(credentialsId: 'nexus-user', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD' )]){
                        sh 'docker login -u $USERNAME -p $PASSWORD ${NEXUS_URL}'
                        sh 'docker tag devops/app:latest ${NEXUS_URL}/devops/app'
                        sh 'docker push ${NEXUS_URL}/devops/app'
                    }
                }
            }
        }
    }
    
}
