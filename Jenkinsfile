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
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/manojphaju/jenkins_terraform.git'
            }
        }

        stage('Terraform Init & Plan') {
            steps {
                sh 'terraform init'
                sh 'terraform plan -out=tfplan'
                sh 'terraform show -no-color tfplan > tfplan.txt'
            }
        }

        stage('Approval') {
            when {
                not {
                    equals expected: true, actual: params.autoApprove
                }
            }
            steps {
                script {
                    // Read plan from workspace root
                    def plan = readFile 'tfplan.txt'
                    input message: "Do you want to apply the plan?",
                          parameters: [
                              text(
                                  name: 'Plan', 
                                  description: 'Please review the plan below', 
                                  defaultValue: plan
                              )
                          ]
                }
            }
        }

        stage('Apply') {
            steps {
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

    post {
        always {
            archiveArtifacts artifacts: 'tfplan.txt', fingerprint: true
        }
    }
}
