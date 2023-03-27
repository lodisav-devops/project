folder('diplom') {
    description('<div style="border-radius:10px; text-align: center; font-size:120%; padding:15px; background-color: powderblue;">Test kubectl and app</div>')
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

folder('app') {
    description('<div style="border-radius:10px; text-align: center; font-size:120%; padding:15px; background-color: powderblue;">App calculator CI/CD</div>')
}

multibranchPipelineJob('app/build_or_deploy') {
    branchSources {
        branchSource {
            source {
                github {
                    id('1234567') // IMPORTANT: use a constant and unique identifier
                    credentialsId('github_PAT')
                    repoOwner('lodisav-devops')
                    repository('calculator')
                    repositoryUrl('https://github.com/lodisav-devops/calculator')
                    configuredByUrl(true)
                    traits {
                        gitHubBranchDiscovery {
                            strategyId(3)
                        }
                        gitHubPullRequestDiscovery {
                            strategyId(1)
                        }
                        headWildcardFilter  {
                            includes("master PR-*")
                            excludes("")
                        }
                    }
                }
            }
        }
    }
    factory {
        workflowBranchProjectFactory {
            scriptPath('jenkins/Jenkinsfile')
        }
    }
}
