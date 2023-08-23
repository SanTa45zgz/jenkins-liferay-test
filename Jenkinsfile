pipeline {
  agent any
  parameters {
    booleanParam(name: 'DES', defaultValue: false)
    booleanParam(name: 'PRE', defaultValue: false)
    booleanParam(name: 'PRO', defaultValue: false)
  }
  stages {
    stage('build themas DES') {
      when {
        expression {params.DES == true}
      }
      steps {
        sh 'dos2unix gradlew && gradle deploy'
      }
    }
    stage('build DES') {
      when {
        expression {params.DES == true}
      }
      steps {
        sh 'cd modules && gradle build' 
      }
    }
    stage('Deploy DES') {
     when {
        expression {params.PRE == true}
      }
      steps {
        sh 'scp -r -i "~/.ssh/liferaytest.lgp.ehu.es" -o StrictHostKeyChecking=no modules/*/build/libs/*.jar liferay@liferaytest.lgp.ehu.es:/opt/liferay/deploy'
        sh 'scp -r -i "~/.ssh/liferaytest.lgp.ehu.es" -o StrictHostKeyChecking=no themes/*/dist/*.war liferay@liferaytest.lgp.ehu.es:/opt/liferay/deploy'
      }
    }
    
    stage('Clean workspace') {
      steps {
          cleanWs()
      }
    }
  }
}
