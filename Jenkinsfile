pipeline {
    agent any
    tools{
        jdk 'JDK17'
        nodejs 'NODEJS16'
    }
    environment {
        SCANNER_HOME=tool 'Sonar-scanner'
    }
    stages {
        stage('clean workspace') {
            steps{
                cleanWs()
            }
        }
        stage('Checkout from Git') {
            steps{
                git branch: 'Netflix', url: 'https://github.com/Ronit-hub-007/NetflixCloneProject.git'
            }
        }
        // stage("Sonarqube Analysis ") {
        //     steps{
        //         withSonarQubeEnv('Sonarqube') {
        //             sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Netflix \
        //             -Dsonar.projectKey=Netflix '''
        //         }
        //     }
        // }
        // stage("quality gate") {
        //    steps {
        //         script {
        //             waitForQualityGate abortPipeline: false, credentialsId: 'Sonarqube-token' 
        //         }
        //     } 
        // }
        // stage('Install Dependencies') {
        //     steps {
        //         sh "npm install"
        //     }
        // }
        // stage('OWASP FS SCAN') {
        //     steps {
        //         dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit', odcInstallation: 'DP-Check'
        //         dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
        //     }
        // }
        // stage('TRIVY FS SCAN') {
        //     steps {
        //         sh "trivy fs . > trivyfs.txt"
        //     }
        // }
        // stage("Docker Build & Push") {
        //     steps {
        //         script {
        //             withDockerRegistry(credentialsId: 'DockerHubCreds', toolName: 'docker') {
        //                 sh "docker build --build-arg KEY_API_TMDB=${TMDB_API_Key} -t netflixclone ."
        //                 sh "docker tag netflixclone rohtmore007/netflixclone:latest "
        //                 sh "docker tag netflixclone rohtmore007/netflixclone:V${BUILD_NUMBER} "
        //                 sh "docker push rohtmore007/netflixclone:latest "
        //                 sh "docker push rohtmore007/netflixclone:V${BUILD_NUMBER} "
        //             }
        //         }
        //     }
        // }

        stage("Docker Build & Push") {
            steps {
                script {
                    // Use DockerHubCreds for Docker registry authentication
                    withDockerRegistry(credentialsId: 'DockerHubCreds', toolName: 'docker') {
                        // Access TMDB_API_Key_Credential to get the secret text
                        def tmdbApiKey = credentials('TMDB_API_Key')
                        
                        // Build Docker image with TMDB_API_Key as a build argument
                        sh "docker build --build-arg KEY_API_TMDB=${tmdbApiKey} -t netflixclone ."
                        
                        // Tag the Docker image
                        sh "docker tag netflixclone rohtmore007/netflixclone:latest "
                        sh "docker tag netflixclone rohtmore007/netflixclone:V${BUILD_NUMBER} "
                        
                        // Push Docker images to DockerHub
                        sh "docker push rohtmore007/netflixclone:latest "
                        sh "docker push rohtmore007/netflixclone:V${BUILD_NUMBER} "
                    }
                }
            }
        }
        stage("TRIVY") {
            steps{
                sh "trivy image rohtmore007/netflixclone:latest > trivyimage.txt" 
            }
        }
        stage('Deploy to container') {
            steps{
                sh 'docker run -d --name netflix -p 80:80 sevenajay/netflix:latest'
            }
        }
    }
    post {
        always {
        emailext attachLog: true,
            subject: "'${currentBuild.result}'",
            body: "Project: ${env.JOB_NAME}<br/>" +
                "Build Number: ${env.BUILD_NUMBER}<br/>" +
                "URL: ${env.BUILD_URL}<br/>",
            to: 'rmore4889@gmail.com,thesagarshah33@gmail.com',
            attachmentsPattern: 'trivyfs.txt,trivyimage.txt'
        }
    }
}