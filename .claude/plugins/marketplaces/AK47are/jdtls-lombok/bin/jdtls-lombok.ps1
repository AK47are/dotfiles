#!/usr/bin/env pwsh

$env:JAVA_HOME = (scoop prefix openjdk)

$MASON = "$env:LOCALAPPDATA\nvim-data\mason"

$jdtls = "$MASON\bin\jdtls.cmd"
$lombokJar = "$MASON\share\jdtls\lombok.jar"

& $jdtls "--jvm-arg=-javaagent:$lombokJar" @args
