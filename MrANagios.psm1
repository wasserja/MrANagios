# MrANagios Script Module


# Set global default parameter values for ApiUrl and ApiKey
# Change these values to match your environment.
$Global:PSDefaultParameterValues["*:ApiUrl"]="https://nagiosxi.yourdomain.com/nagiosxi/api/v1/"
$Global:PSDefaultParameterValues["*:ApiKey"]="PutYourAPIKeyHere"

# Source all ps1 files from module directory.
# https://becomelotr.wordpress.com/2017/02/13/expensive-dot-sourcing/
foreach ($file in Get-ChildItem $PSScriptRoot\*.ps1) {
    $ExecutionContext.InvokeCommand.InvokeScript(
        $false, 
        (
            [scriptblock]::Create(
                [io.file]::ReadAllText(
                    $file.FullName,
                    [Text.Encoding]::UTF8
                )
            )
        ), 
        $null, 
        $null
    )
}