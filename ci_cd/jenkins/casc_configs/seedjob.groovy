folder('diplom') {
    description('<div style="border-radius:10px; text-align: center; font-size:120%; padding:15px; background-color: powderblue;">Test kubectl</div>')
}

pipelineJob('diplom/kubectl_test') {
    description('<div style="border-radius:10px; text-align: center; font-size:120%; padding:15px; background-color: powderblue;">Create pipeline test kubectl</div>')
    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        github('lodisav-devops/test-jenkins', 'ssh')
                        credentials('github_ssh')
                    }
                    branch('master')
                }
            }
            scriptPath('docker/Jenkinsfile')
        }
    }
}

pipelineJob('diplom/app') {
    description('<div style="border-radius:10px; text-align: center; font-size:120%; padding:15px; background-color: powderblue;">Create pipeline app calculator</div>')
    definition {
        cpsScm {
            scm {
                git {
                    remote {
                        github('lodisav-devops/calculator', 'ssh')
                        credentials('github_ssh')
                    }
                    branch('master')
                }
            }
            scriptPath('jenkins/Jenkinsfile')
        }
    }
}

// pipelineJob('infra/infra_destroy') {
//     description('<div style="border-radius:10px; text-align: center; font-size:120%; padding:15px; background-color: powderblue;">Destroy infra pipeline</div>')
//     definition {
//         cpsScm {
//             scm {
//                 git {
//                     remote {
//                         github('DOS11-onl/example', 'ssh')
//                         credentials('github_ssh')
//                     }
//                     branch('diplom')
//                 }
//             }
//             scriptPath('diplom/terraform/infra/jenkinsfile_destroy')
//         }
//     }
// }

// folder('app') {
//     description('<div style="border-radius:10px; text-align: center; font-size:120%; padding:15px; background-color: powderblue;">App CI/CD</div>')
// }

// multibranchPipelineJob('app/build') {
//     branchSources {
//         branchSource {
//             source {
//                 github {
//                     id('1234567') // IMPORTANT: use a constant and unique identifier
//                     credentialsId('github_PAT')
//                     repoOwner('DOS11-onl')
//                     repository('simple-java-maven-app')
//                     repositoryUrl('https://github.com/DOS11-onl/simple-java-maven-app')
//                     configuredByUrl(true)
//                     traits {
//                         gitHubBranchDiscovery {
//                             strategyId(3)
//                         }
//                         gitHubPullRequestDiscovery {
//                             strategyId(1)
//                         }
//                         headWildcardFilter  {
//                             includes("master PR-*")
//                             excludes("")
//                         }
//                     }
//                 }
//             }
//         }
//     }
//     factory {
//         workflowBranchProjectFactory {
//             scriptPath('jenkins/Jenkinsfile')
//         }
//     }
//     // orphanedItemStrategy {
//     //     discardOldItems {
//     //         numToKeep(5)
//     //     }
//     // }
// }
