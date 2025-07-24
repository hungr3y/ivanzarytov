package aws.buildTypes

import _self.trimToLine
import _self.vcsRoots.GitVcsAws
import jetbrains.buildServer.configs.kotlin.BuildType
import jetbrains.buildServer.configs.kotlin.ParameterDisplay
import jetbrains.buildServer.configs.kotlin.buildFeatures.dockerSupport
import jetbrains.buildServer.configs.kotlin.buildSteps.ScriptBuildStep
import jetbrains.buildServer.configs.kotlin.buildSteps.script

object BuildAMI : BuildType({
    id("BuildAmi")
    name = "Build AMI"

    vcs {
        root(GitVcsAws)
    }
    params {
        text("git.short.hash", "", display = ParameterDisplay.HIDDEN)
        text("version", "", display = ParameterDisplay.HIDDEN)
        checkbox(
            "dry.run",
            "false",
            checked = "true",
            unchecked = "false",
            display = ParameterDisplay.NORMAL,
            description = "Do not create AMI after build"
        )
        checkbox(
            "force.deregister",
            "false",
            checked = "true",
            unchecked = "false",
            display = ParameterDisplay.NORMAL,
            description = "Deregister AMI with the same name if exist"
        )
    }

    steps {
        script {
            name = "Set AMI version"
            id = "SetAMIVersion"
            scriptContent = """
                VCS_NUM=%build.vcs.number%
                VCS_SHORT=${'$'}{VCS_NUM:0:8}
                echo "##teamcity[setParameter name='git.short.hash' value='${'$'}VCS_SHORT']"
                echo "##teamcity[setParameter name='version' value='R3-AL2023-${'$'}VCS_SHORT']"
                echo "##teamcity[buildStatus text='{build.status.text}: R3-AL2023-${'$'}VCS_SHORT']"
                echo "##teamcity[buildNumber '%build.number%: R3-AL2023-${'$'}VCS_SHORT']"
            """.trimIndent()
        }
        script {
            name = "Packer build"
            id = "PackerBuild"
            scriptContent = """
                packer init packer/backend && 
                packer build 
                -var "force_deregister=%force.deregister%"
                -var "skip_create_ami=%dry.run%"
                -var "ami_name=%version%"
                -var "access_key=%system.sh.aws.access.key%" 
                -var "secret_key=%system.sh.aws.secret.key%" 
                packer/backend
            """.trimToLine()
            dockerImagePlatform = ScriptBuildStep.ImagePlatform.Linux
            dockerPull = true
            dockerImage = "%system.sh.artifactory%/%system.artifactory.r3_docker%/tools/ansible-packer:10.2.0-1.11.2"
        }
    }

    features {
        dockerSupport {
            loginToRegistry = on {
                dockerRegistryId = "DOCKER_REGISTRY"
            }
        }
    }

    requirements {
        doesNotEqual("env.OS", "Windows_NT")
    }
})
