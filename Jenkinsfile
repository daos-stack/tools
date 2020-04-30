#!/usr/bin/groovy

target_branch = env.CHANGE_TARGET ? env.CHANGE_TARGET : env.BRANCH_NAME

pipeline {
    agent { label 'lightweight' }

    triggers {
        cron(env.BRANCH_NAME == 'master' ? '@monthly' : '')
    }

    stages {
        stage ('tools') {
        parallel {
            stage ('bullseye') {
                steps {
                    sh script: './get_bullseye.sh',
                       label: 'Get Bullseye'
                } // steps
                post {
                  success {
                      archiveArtifacts artifacts: 'bullseyecoverage-linux.tar'
                  }
                } // post
            } // stage ('bullseye')
            stage ('bullshtml') {
                steps {
                    sh script: './get_bullshtml.sh',
                       label: 'Get bullshtml'
                }
                post {
                  success {
                      archiveArtifacts artifacts: 'bullshtml.jar'
                  }
                } // post
            } // stage ('bullshtml')
        } // parallel
        } // stage ('tools')
    } // stages
    post {
        unsuccessful {
            notifyBrokenBranch branches: target_branch
        }
    } // post
} // pipeline
