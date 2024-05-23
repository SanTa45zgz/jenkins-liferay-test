pipeline {
  agent any
  parameters {
    choice(
      name: 'DEPLOY_ENV',
      choices: ['TES', 'DES'],
      description: 'Select deployment environment'
    )
    booleanParam(
      defaultValue: false,
      description: 'Selecciona si deseas un despliegue completo',
      name: 'FULL_DEPLOY'
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
      steps {
        script {
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
    stage('Elegir Modulo/s o Tema/s') {
      when {
        expression { !params.FULL_DEPLOY }
      }
      steps {
        script {
          def modules = sh(
            script: 'find ./ -type f -iname *.war -o -type f -iname *.jar | grep -E \'./modules/.*/build/libs/.*.jar|themes/.*/dist/.*.war\' | sed \'s/$/,/\' ',
            returnStdout: true
          ).trim()

          def selectedModules = input(
            message: 'Por favor elige el modulo o tema a desplegar',
            parameters: [
              extendedChoice(
                name: 'MODULOS',
                type: 'PT_CHECKBOX',
                defaultValue: '',
                description: 'Modulos o temas a desplegar',
                quoteValue: false,
                multiSelectDelimiter: ' ',
                saveJSONParameterToFile: false,
                value: modules, // Aquí definimos las opciones
                visibleItemCount: 5
              )
            ])
          env.MODULES_SELECTED = selectedModules
        }
      }
    }
    stage('Renombrar archivos') {
      steps {
        script {
          sh '''
            for file in $(find modules/*/build/libs/*.jar themes/*/dist/*.war); do
              base_name=$(basename $file)
              no_version_name=$(echo $base_name | sed -E 's/-[0-9]+\\.[0-9]+\\.[0-9]+//')
              mv -u $file $(dirname $file)/$no_version_name
            done
          '''
        }
      }
    }
    stage ('Desplegar ENV') {
      when {
        expression { params.DEPLOY_ENV != 'NONE' }
      }
      steps{
        script {
          if (params.DEPLOY_ENV == 'TES') {
            if (!params.FULL_DEPLOY) {
               echo "${env.MODULES_SELECTED}"
               def modulesSelected = env.MODULES_SELECTED
               echo "Modules Selected: $modulesSelected"
               sh "scp -i \"~/.ssh/liferaytest.lgp.ehu.es\" -o StrictHostKeyChecking=no $modulesSelected liferay@liferaytest.lgp.ehu.es:/opt/liferay/deploy"
            } else {
                sh 'scp -r -i "~/.ssh/liferaytest.lgp.ehu.es" -o StrictHostKeyChecking=no modules/*/build/libs/*.jar liferay@liferaytest.lgp.ehu.es:/opt/liferay/deploy'
                sh 'scp -r -i "~/.ssh/liferaytest.lgp.ehu.es" -o StrictHostKeyChecking=no themes/*/dist/*.war liferay@liferaytest.lgp.ehu.es:/opt/liferay/deploy'
                echo "FULL DEPLOY"
            }
          }
          // Agrega lógica similar para los otros entornos (DES, PRE y PRO) si es necesario
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