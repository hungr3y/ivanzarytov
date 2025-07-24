package aws

import aws.buildTypes.BuildAMI
import aws.buildTypes.BuildAwsScripts
import aws.buildTypes.GrafanaDashboardSync
import jetbrains.buildServer.configs.kotlin.Project


object Project : Project({
    id("AWS")
    name = "AWS"
    
    buildType(BuildAMI)
})
