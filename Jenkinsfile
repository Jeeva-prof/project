pipeline {
    agent any
    stages{
        stage('checkout SCM'){
            steps{
	        git 'https://github.com/Jeeva-prof/project.git'
            }
        }
        stage('compile project'){
            steps{
	        sh 'mvn compile'           
            }
        }
        stage('test project'){
            steps{
	        sh 'mvn compile'           
            }
        }
        stage('build project'){
            steps{
	        sh 'mvn clean package'
            }
        }
        stage('qa project'){
            steps{
                sh 'mvn checkstyle:checkstyle'
            }
        }
        stage('Build docker image'){
            steps{
                script{
                    sh 'docker build -t 10551jeeva/finance:v1 . '
                    sh 'docker images'
                }
            }
        }
        
	stage('Docker login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-pwd', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                    sh "echo $PASS | docker login -u $USER --password-stdin"
                    sh 'docker push 10551jeeva/finance:v1'
                }
            } 
 	}       
     stage('Deploy to testserver') {
            steps {
		sh 'su - devops'
                sh 'sudo ansible-playbook testserver.yml'
                  
                }
            }
     stage('Deploy to production server') {
            steps {
		sh 'su - devops'
                sh 'sudo ansible-playbook productionserver.yml'
                  
                }
            }
        }
}
