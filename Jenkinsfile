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
   // stage('Deploy ML') {
   //  when {
   //     expression {params.PRE == true}
   //   }
   //   steps {
   //     sh 'ssh -o StrictHostKeyChecking=no hiberus@10.50.210.6 "rm -rf /var/www/mobile/backend/ml"'
   //     sh 'ssh -o StrictHostKeyChecking=no hiberus@10.50.210.6 "cp -R /var/www/mobile/package /var/www/mobile/backend/ml"'
   //    sh 'ssh -o StrictHostKeyChecking=no -t "hiberus@10.50.210.6" \'bash -i -c "pm2 restart ml_api"\''
   //   }
   // }
    
    stage('Clean workspace') {
      steps {
          cleanWs()
      }
    }
  }
}
