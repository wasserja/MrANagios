# MrANagios Script Module


# Set global default parameter values
# Change these values to match your environment.

$Global:PSDefaultParameterValues["*:NagiosXiApiUrl"]="https://nagiosxi.domain.com/nagiosxi/api/v1/"
$Global:PSDefaultParameterValues["*:NagiosXiApiKey"]="YourNagiosXiApiKeyHere"
$Global:PSDefaultParameterValues["*:NagiosCoreUrl"]='https://nagiosxi.domain.com/nagios'

# Optionally read nagios credentials from CliXml file on disk.
$NagiosCredentialFile = 'C:\Scripts\NagiosLogon.xml'

if (Test-Path $NagiosCredentialFile) {
    Write-Verbose "$NagiosCredentialFile exists. Importing credential from file."
    $Credential = Import-Clixml -Path $NagiosCredentialFile
    $Global:PSDefaultParameterValues['*Nagios*:Credential']=$Credential
    }
else {
    Write-Verbose 'No credential file found.'
    $Global:PSDefaultParameterValues["*:username"]=$env:USERNAME
    }



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