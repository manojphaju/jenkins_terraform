pipeline {
    agent any

    parameters {
        booleanParam(
            name: 'autoApprove',
            defaultValue: false,
            description: 'Automatically run apply after generating plan?'
        )
    }

    environment {
        // Make AWS CLI and Terraform visible to all sh steps
        PATH = "/usr/local/bin:/opt/homebrew/bin:${env.PATH}"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/manojphaju/jenkins_terraform.git'
            }
        }

        // Wrap all Terraform/AWS stages in withCredentials
        stage('Terraform Workflow') {
            steps {
                withCredentials([
                    string(credentialsId: 'AWS_ACCESS_KEY_ID', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'AWS_SECRET_ACCESS_KEY', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    script {
                        // ----------------------
                        // Stage: Verify AWS Connectivity
                        // ----------------------
                        stage('Verify AWS Connectivity') {
                            sh '''
                                echo "Checking AWS connectivity..."
                                aws sts get-caller-identity
                            '''
                        }

                        // ----------------------
                        // Stage: Terraform Init
                        // ----------------------
                        stage('Terraform Init') {
                            sh '''
                                echo "Initializing Terraform..."
                                terraform init
                            '''
                        }

                        // ----------------------
                        // Stage: Terraform Plan
                        // ----------------------
                        stage('Terraform Plan') {
                            sh '''
                                echo "Running Terraform Plan..."
                                terraform plan -out=tfplan -input=false
                                terraform show -no-color tfplan > tfplan.txt
                            '''
                        }

                        // ----------------------
                        // Stage: Approval before Apply
                        // ----------------------
                        stage('Approval') {
                            when {
                                expression { return !params.autoApprove }
                            }
                            steps {
                                input message: "Terraform plan generated. Do you want to apply?",
                                      parameters: [
                                          booleanParam(
                                              name: 'Proceed',
                                              defaultValue: true,
                                              description: 'Approve Terraform apply?'
                                          )
                                      ]
                            }
                        }

                        // ----------------------
                        // Stage: Terraform Apply
                        // ----------------------
                        stage('Terraform Apply') {
                            def applyCmd = "terraform apply -input=false tfplan"
                            if (params.autoApprove) {
                                applyCmd += " -auto-approve"
                            }
                            sh applyCmd
                        }

                        // ----------------------
                        // Stage: Terraform Destroy
                        // ----------------------
                        stage('Terraform Destroy') {
                            input message: "Do you want to destroy all Terraform-managed resources?",
                                  parameters: [
                                      booleanParam(
                                          name: 'ProceedDestroy',
                                          defaultValue: false,
                                          description: 'Approve Terraform destroy?'
                                      )
                                  ]
                            sh 'terraform destroy -auto-approve'
                        }
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
