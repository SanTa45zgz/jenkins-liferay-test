pipeline {
  agent any
  parameters {
    activeChoice(
      name: 'DEPLOY_ENV',
      defaultValue: 'DES',
      description: 'Select deployment environment',
      script: [
        $class: 'GroovyScript',
        script: [
          classpath: [],
          sandbox: true,
          script: """
            return ['DES', 'PRE', 'PRO']
          """
        ]
      ]
    )
    activeChoice(
      name: 'COMMIT',
      defaultValue: 'HEAD',
      description: 'Select one of the last 5 commits',
      script: [
        $class: 'GroovyScript',
        script: [
          classpath: [],
          sandbox: true,
          script: """
            def commits = "git log --oneline -n 5 --pretty=format:'%h %s'".execute().text
            return commits.split('\\n').collect { it.trim() }
          """
        ]
      ]
    )
  }  
  stages {
    stage('Build') {
      steps {
        script {
          def selectedCommit = params.COMMIT
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
            sh 'scp -r -i "~/.ssh/liferaytest.lgp.ehu.es" -o StrictHostKeyChecking=no modules/*/build/libs/*.jar liferay@liferaytest.lgp.ehu.es:/opt/liferay/deploy'
            sh 'scp -r -i "~/.ssh/liferaytest.lgp.ehu.es" -o StrictHostKeyChecking=no themes/*/dist/*.war liferay@liferaytest.lgp.ehu.es:/opt/liferay/deploy'
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

