pipeline {
    agent { label "built-in"}

    stages {
        stage('Build') {
            steps {
                echo 'Building..'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
    post { 
        always { 
            echo 'I will always run whether the job is success or failure'
        }
        sucess {
            echo "I,will run only when the job is success"
        }
        failure{
            echo "I,will run only when the job is failure"
        }
    }
}