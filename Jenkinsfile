pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-2'
        TF_IN_AUTOMATION = 'true'
        TF_VERSION = '1.9.8'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/kelleydmoore-aws/kdm-class7hw-3.24.26'
            }
        }

        stage('Terraform Format') {
            steps {
                // Fails the build if code is not properly formatted
                sh 'terraform fmt -check'
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'b307e5d6-3678-450b-9102-28fa4e5e6dc2'
                ]]) {
                    sh '''
                    terraform init \
                    -backend-config="bucket=jenkins-321528232261-us-east-2-an" \
                    -backend-config="key=jenkins/jenkins-s3-kdm.tfstate" \
                    -backend-config="region=us-east-2" \
                    -backend-config="encrypt=true"
                    '''
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                // Requirement Met: Ensures configuration is syntactically valid and internally consistent
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan & Apply') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'b307e5d6-3678-450b-9102-28fa4e5e6dc2'
                ]]) {
                    sh '''
                    terraform plan -out=tfplan
                    terraform apply -auto-approve tfplan
                    '''
                }
            }
        }

        stage('Optional Destroy') {
            steps {
                script {
                    def destroyChoice = input(
                        message: 'Do you want to initiate terraform destroy?',
                        ok: 'Submit',
                        parameters: [
                            choice(name: 'DESTROY', choices: ['no', 'yes'], description: 'Select yes to destroy resources')
                        ]
                    )

                    if (destroyChoice == 'yes') {
                        withCredentials([[
                            $class: 'AmazonWebServicesCredentialsBinding',
                            credentialsId: 'b307e5d6-3678-450b-9102-28fa4e5e6dc2'
                        ]]) {
                            sh 'terraform destroy -auto-approve'
                        }
                    } else {
                        echo "Skipping destroy stage as requested."
                    }
                }
            }
        }
    }

    post {
        always {
            cleanWs() // Good practice: Clean the workspace after the run
        }
    }
}