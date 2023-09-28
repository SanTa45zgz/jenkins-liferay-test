pipeline {
  agent any
  parameters {
    choice(
      name: 'DEPLOY_ENV',
      choices: ['DES', 'PRE', 'PRO'],
      description: 'Select deployment environment'
    )
    choice(
      name: 'COMMIT',
      choices: 'Selecciona un commit en la siguiente ejecución',
      description: 'Select one of the last 5 commits'
    )
  }
  stages {
  stage('Get Commits') {
      when {
        expression { params.COMMIT == 'Selecciona un commit en la siguiente ejecución' }
      }
      steps {
        script {
          def commits = sh(
            script: 'git log --oneline -n 5 --pretty=format:"%h %s"',
            returnStdout: true
          ).trim()
          // Dividir los commits y agregarlos a la lista de opciones
          params.COMMIT = commits.split('\n')
        }
      }
    }
    stage('Build') {
      steps {
        script {
          def selectedCommit = params.COMMIT[0]
	  selectedCommit = selectedCommit.split(' ')[0]
          sh "git checkout $selectedCommit"
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

