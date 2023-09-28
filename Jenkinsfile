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
     stage('Cargando los ultimos 5 commits') {
        steps {
                script {
                    env.COMMITS = sh (script: 'git log --oneline -n 5 --pretty=format:"%h %s"', returnStdout: true).trim()
                }
            }
        }
      stage('Seleccion de commit a desplegar') {
            steps{
                script{
                    echo "Por favor elige el commit a buildear"
                    env.COMMIT_SCOPE = input message: 'Por favor elige el commit a buildear', ok: 'Validate!',
                            parameters: [choice(name: 'COMMIT_HASH', choices: "${env.COMMITS}", description: 'Commit to build?')]
                }
            }
        } 
        stage("checkout commit") {
            steps {
		script {
		   echo "${env.COMMIT_SCOPE}"
		   def selectedCommit = env.COMMIT_SCOPE.split(' ')[0]
                   sh "git checkout $selectedCommit"
		}
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

    stage('Selecciona tema/modulo a desplegar'){
	steps {
                script {
                    env.MODULES = sh (script: 'find ./ -type f -iname \*.war -o -type f -iname \*.jar ', returnStdout: true).trim()
                    
                }
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
            sh 'echo "${env.MODULES}"'
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
