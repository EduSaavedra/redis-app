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
    }
    
}
