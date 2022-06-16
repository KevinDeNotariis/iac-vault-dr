pipeline {
  agent {
    docker {
      image 'centos:my-centos'
      args '-u 0:0 --privileged'
    }
  }

  stages {
    stage("Gather Vault Tokens") {
      steps {
        script {
          env.DEV_VAULT_TOKEN = input(message: 'Insert DEV Vault Token', id: 'DEV_VAULT_TOKEN', parameters: [string(name: 'Dev Token')])
          env.STAGE_VAULT_TOKEN = input(message: 'Insert STAGE Vault Token', id: 'STAGE_VAULT_TOKEN', parameters: [string(name: 'Stage Token')])
          env.PROD_VAULT_TOKEN = input(message: 'Insert PROD Vault Token', id: 'PROD_VAULT_TOKEN', parameters: [string(name: 'Prod Token')])
          env.VAULT_SKIP_VERIFY = "true"
        }
      }
    }

    stage('Install Dependencies') {
      steps {
        sh 'make install-dependencies'
      }
    }

    stage("Run Tests") {
      when {
        not {
          branch 'master'
        }
      }
      parallel {
        stage("Test on DEV") {
          environment {
            ENV = "dev"
          }
          steps {
            sh "make test/checkov"
          }
        }
        stage("Test on STAGE") {
          environment {
            ENV = "stage"
          }
          steps {
            sh "make test/checkov"
          }
        }
        stage("Test on PROD") {
          environment {
            ENV = "prod"
          }
          steps {
            sh "make test/checkov"
          }
        }
      }
    }

    stage('Terraform Plan') {
      when {
        // When a Pull-request
        allOf {
          changeRequest target: 'master'
        }
      }
      parallel {
        stage("Plan on DEV") {
          environment {
            ENV = "dev"
          }
          steps {
            withEnv(["VAULT_TOKEN=${DEV_VAULT_TOKEN}"]) {
              withAWS(region: 'us-east-1', credentials: 'my-aws-credentials') {
                sh "make terraform/init"
                sh "make terraform/plan"
              }
            }
          }
        }
        stage("Plan on STAGE") {
          environment {
            ENV = "stage"
          }
          steps {
            withEnv(["VAULT_TOKEN=${STAGE_VAULT_TOKEN}"]) {
              withAWS(region: 'us-east-1', credentials: 'my-aws-credentials') {
                sh "make terraform/init"
                sh "make terraform/plan"
              }
            }
          }
        }
        stage("Plan on PROD") {
          environment {
            ENV = "prod"
          }
          steps {
            withEnv(["VAULT_TOKEN=${PROD_VAULT_TOKEN}"]) {
              withAWS(region: 'us-east-1', credentials: 'my-aws-credentials') {
                sh "make terraform/init"
                sh "make terraform/plan"
              }
            }
          }
        }
      }
    }

    stage('Terraform Apply') {
      when {
        // Not a Pull Request (AKA a merge on master)
        allOf {
          not {
            changeRequest target: 'master'
          }
          branch 'master'
        }
      }
      parallel {
        stage("Apply on DEV") {
          environment {
            ENV = "dev"
          }
          steps {
            withEnv(["VAULT_TOKEN=${DEV_VAULT_TOKEN}"]) {
              withAWS(region: 'us-east-1', credentials: 'my-aws-credentials') {
                sh "make terraform/init"
                sh "make terraform/plan"
                sh "make terraform/apply"
              }
            }
          }
        }
        stage("Apply on STAGE") {
          environment {
            ENV = "stage"
          }
          steps {
            withEnv(["VAULT_TOKEN=${STAGE_VAULT_TOKEN}"]) {
              withAWS(region: 'us-east-1', credentials: 'my-aws-credentials') {
                sh "make terraform/init"
                sh "make terraform/plan"
                sh "make terraform/apply"
              }
            }
          }
        }
        stage("Apply on PROD") {
          environment {
            ENV = "prod"
          }
          steps {
            withEnv(["VAULT_TOKEN=${PROD_VAULT_TOKEN}"]) {
              withAWS(region: 'us-east-1', credentials: 'my-aws-credentials') {
                sh "make terraform/init"
                sh "make terraform/plan"
                sh "make terraform/apply"
              }
            }
          }
        }
      }
    }
  }

  post {
    always {
      sh "rm -rf terraform"
    }
  }
}