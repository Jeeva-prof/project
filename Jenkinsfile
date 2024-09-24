pipeline {
    agent any
    stages{
        stage('checkout SCM'){
            steps{
	        git credentialsId: 'git-pwd', url: 'https://github.com/Jeeva-prof/project.git'
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
     	stage('Create testserver') {
            steps {
	        sh '''cd iac 
		sudo terraform init
		sudo terraform apply --auto-approve
		sudo terraform output -raw testip >testhost | pwd 
    sudo sed -i \'\'s/localhost/$(cat testhost)/\'\' prometheus_test.yml
    sudo sed -i \'\'s/localhost/$(cat testhost)/\'\' dash/test_dash.json
  	sudo sed -i \'\'s/localhost/$(cat testhost)/\'\' ds/test_ds_.yaml 
		sudo sed -i \'s/$/  ansible_user=ubuntu/\' testhost'''   
		          }
	    }
     	stage('Deploy to testserver') {
            steps {
		   sh 'sudo ansible-playbook -i iac/testhost testserver.yml'
		          }
	    }
     	stage('Create production server') {
            steps {
      		sh '''sudo pwd
		            cd iac
		            sudo terraform output -raw prodip >prodhost
                sudo sed -i \'\'s/localhost/$(cat prodhost)/\'\' prometheus_production.yml
                sudo sed -i \'\'s/localhost/$(cat prodhost)/\'\' dash/prod_dash.json
                sudo sed -i \'\'s/localhost/$(cat prodhost)/\'\' ds/prod_ds_.yaml
  		          sudo sed -i \'s/$/  ansible_user=ubuntu/\' prodhost '''
		          }
	    }
	 stage('Deploy to production server') {
            steps {
		sh 'sudo ansible-playbook -i iac/prodhost productionserver.yml'
                
                }
            }
	 stage('Setup continous monitoring ') {
            steps {
		          sh '''  sudo ansible-playbook iac/playbookgrafana.yaml'''
                
                }
            }
        }
    }   
