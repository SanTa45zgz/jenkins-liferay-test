pipeline {
  agent any
  parameters {
    choice(
      name: 'DEPLOY_ENV',
      choices: ['DES', 'PRE', 'PRO'],
      description: 'Select deployment environment'
    )
  }
  stages {
     stage('checkout scm') {
        steps {
                script {
                    def COMMITS = sh 'git log --oneline -n 5 --pretty=format:"%h %s"'
                }
            }
        }
      stage('get build Params User Input') {
            steps{
                script{
                    echo "Por favor elige el commit a buildear"
                    env.COMMIT_SCOPE = input message: 'Por favor elige el commit a buildear', ok: 'Validate!',
                            parameters: [choice(name: 'COMMIT_HASH', choices: "${COMMITS}", description: 'Commit to build?')]
                }
            }
        } 
        stage("checkout the commit") {
            steps {
                echo "${env.COMMIT_SCOPE}"
		def selectedCommit = env.COMMIT_SCOPE.split(' ')[0]
                sh "git checkout $selectedCommit"
            }
        }
    
    stage('Build') {
      steps {
        script {
          sh 'dos2unix gradlew && gradle deploy'
	  sh 'cd modules && gradle build'
        }
      }
    }
    
    stage ('Deploy ENV') {
      when {
        expression { params.DEPLOY_ENV != 'NONE' }
      }
      steps{
	script {
	  if (params.DEPLOY_ENV == 'DES') {
            //sh 'scp -r -i "~/.ssh/liferaytest.lgp.ehu.es" -o StrictHostKeyChecking=no modules/*/build/libs/*.jar liferay@liferaytest.lgp.ehu.es:/opt/liferay/deploy'
            //sh 'scp -r -i "~/.ssh/liferaytest.lgp.ehu.es" -o StrictHostKeyChecking=no themes/*/dist/*.war liferay@liferaytest.lgp.ehu.es:/opt/liferay/deploy'
            sh 'cat fichero.txt'
	  }
          // Agrega lógica similar para los otros entornos (PRE y PRO) si es necesario
	}
      }

    }
    
    stage('Clean workspace') {
      steps {
        cleanWs()
      }
    }
  }
}
