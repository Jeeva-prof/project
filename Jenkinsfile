pipeline {
    agent any
    stages{
        stage('checkout SCM'){
            steps{
	        git credentialsId: 'git-cred', url: 'https://github.com/Jeeva-prof/project.git'
            }
        }
        stage('Compile Project'){
            steps{
	        sh 'mvn compile'           
            }
        }
        stage('Test Project'){
            steps{
	        sh 'mvn compile'           
            }
        }
        stage('Build Project'){
            steps{
	        sh 'mvn clean package'
            }
        }
        stage('QA Project'){
            steps{
                sh 'mvn checkstyle:checkstyle'
            }
        }
        stage('Build Docker Image'){
            steps{
                script{
                    sh 'docker build -t 10551jeeva/finance:v1 . '
                    sh 'docker images'
                }
            }
        }
        
	stage('Docker Login and Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-pwd', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                    sh "echo $PASS | docker login -u $USER --password-stdin"
                    sh 'docker push 10551jeeva/finance:v1'
                }
            } 
 	}       
     	stage('Create Testserver') {
            steps {
            withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-cred', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
		dir('test'){
	        sh ''' sudo pwd
		 terraform init
		sudo terraform apply --auto-approve
		sudo terraform output -raw testip >testhost | pwd 
   		sudo sed -i  \'\'s/localhost/$(cat testhost)/g\'\' prometheus_test.yml
   		sudo sed -i \'\'s/localhost/$(cat testhost)/g\'\' dash/test_dash.json
  		sudo sed -i \'\'s/localhost/$(cat testhost)/g\'\' ds/test_ds_.yaml 
		sudo sed -i \'s/$/  ansible_user=ubuntu/\' testhost'''   
		          }
	    }
            }
	    }
     	stage('Deploy to Testserver') {
            steps {
		   sh 'sudo ansible-playbook -i test/testhost testserver.yml'
		          }
	    }
     	stage('Create Production Server') {
            steps {
            withCredentials([aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-cred', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
      		dir('prod'){
		sh '''
                terraform init
	       sudo terraform apply --auto-approve
	       sudo terraform output -raw prodip >prodhost
               sudo sed -i \'\'s/localhost/$(cat prodhost)/g\'\' prometheus_production.yml
               sudo sed -i \'\'s/localhost/$(cat prodhost)/g\'\' dash/prod_dash.json
	       sudo sed -i \'\'s/localhost/$(cat prodhost)/g\'\' ds/prod_ds_.yaml
		sudo sed -i \'s/$/  ansible_user=ubuntu/\' prodhost '''
		          }
	    }
            }
	    }
	 stage('Deploy to Production Server') {
            steps {
		sh 'sudo ansible-playbook -i prod/prodhost productionserver.yml'
                
                }
            }
	 stage('Setup Continous Monitoring ') {
            steps {
		          sh '''  sudo ansible-playbook test/playbookgrafana.yaml'''
                  sh '''  sudo ansible-playbook prod/playbookgrafana.yaml'''
                
                }
            }
        }
    }   
