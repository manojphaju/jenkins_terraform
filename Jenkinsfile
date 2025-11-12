pipeline {
    agent any

    parameters {
        booleanParam(
            name: 'autoApprove', 
            defaultValue: false, 
            description: 'Automatically run apply after generating plan?'
        )
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/manojphaju/jenkins_terraform.git'
            }
        }

        stage('Terraform Init & Plan') {
            steps {
                withCredentials([
                    string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    sh '''
                        echo "Starting Terraform Init..."
                        terraform init
                        echo "Running Terraform Plan..."
                        terraform plan -out=tfplan -input=false
                        terraform show -no-color tfplan > tfplan.txt
                    '''
                }
            }
        }

        stage('Approval') {
            when {
                not {
                    equals expected: true, actual: params.autoApprove
                }
            }
            steps {
                input message: "Terraform plan generated. Do you want to apply?",
                      parameters: [
                          booleanParam(name: 'Proceed', defaultValue: true, description: 'Approve apply?')
                      ]
            }
        }

        stage('Apply') {
            steps {
                withCredentials([
                    string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    script {
                        def applyCmd = "terraform apply -input=false tfplan"
                        if (params.autoApprove) {
                            applyCmd += " -auto-approve"
                        }
                        sh applyCmd
                    }
                }
            }
        }
    }

    post {
        always {
            archiveArtifacts artifacts: 'tfplan.txt', fingerprint: true
        }
    }
}
