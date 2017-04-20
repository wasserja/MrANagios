# MrANagios Script Module


# Set global default parameter values
# Change these values to match your environment.

$Global:PSDefaultParameterValues["*:NagiosXiApiUrl"]="https://nagiosxi.domain.com/nagiosxi/api/v1/"
$Global:PSDefaultParameterValues["*:NagiosXiApiKey"]="PutYourAPIKeyHere"
$Global:PSDefaultParameterValues["*:NagiosCoreUrl"]='https://nagiosxi.domain.com/nagios'

# Optionally read nagios credentials from CliXml file on disk.
#requires -Modules MrACredential
$NagiosCredentialFile = 'C:\Credentials\NagiosLogon.xml'
$NagiosCredentialKey = 'C:\Keys\NagiosLogon.key'

if ((Test-Path $NagiosCredentialFile) -and (Test-Path $NagiosCredentialKey)) {
    Write-Verbose "Nagios credential file and key exists. Importing credential from file."
    $Credential = Import-Credential -CredentialFilePath $NagiosCredentialFile -EncryptionKeyPath $NagiosCredentialKey
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