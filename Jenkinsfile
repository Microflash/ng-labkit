pipeline {
  agent { label 'jenkins-labkit' }
  stages {
    stage('Pull source code') {
      steps {
        git 'https://github.com/Microflash/ng-labkit.git'
      }
    }
    stage('Test and Build') {
      steps {
        sh 'docker build --no-cache -t ng-labkit .'
      }
    }
    stage('Tag the build') {
      steps {
        sh 'docker tag ng-labkit nexus/ng-labkit:latest'
      }
    }
  }
  post {
    success {
      echo "SUCCESS: Pipeline ${currentBuild.fullDisplayName} completed"
    }
    failure {
      echo "FAILURE: Pipeline ${currentBuild.fullDisplayName} broken (details at ${env.BUILD_URL})"
    }
  }
}
