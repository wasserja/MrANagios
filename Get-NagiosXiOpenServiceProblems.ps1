<#
.Synopsis
   Get a list of open service problems for from Nagios XI.
.DESCRIPTION
   Get a list of open service problems from Nagios XI using Invoke-NagiosXiApi.
   Open service problems are services in Nagios that are warning, critical, or unknown and that 
   have not been acknowledged on all servers including those that are up and not in a 
   scheduled down time.

   All parameters have default values, but you should change your NagiosXiApiUrl and NagiosXiApiKey to match
   your environment. See the documentation for Invoke-NagiosXiApi.
.PARAMETER Summary
   Provides a summary output of host, service, and status rather than all properties.
.EXAMPLE
   Get-NagiosXiOpenServiceProblems
.EXAMPLE
   Get-NagiosXiOpenServiceProblems | Select-Object -Property host_name,name,status_text
#>
function Get-NagiosXiOpenServiceProblems
{
    [CmdletBinding()]
    [Alias()]
    Param
    (
        [string]$NagiosXiApiUrl,
        [string]$NagiosXiApiKey,
        [switch]$Summary
    )

    Begin
    {
        
    }
    Process
    {
        Write-Verbose 'Getting Nagios XI open service problems.'
        $AllOpenServiceProblems = Get-NagiosXIAllOpenServiceProblems -NagiosXiApiUrl $NagiosXiApiUrl -NagiosXiApiKey $NagiosXiApiKey
        $AllHostProblems = Get-NagiosXIAllHostProblems -NagiosXiApiUrl $NagiosXiApiUrl -NagiosXiApiKey $NagiosXiApiKey
        if ($Summary) {
            Write-Verbose 'Summary Output selected.'
            $AllOpenServiceProblems | where {$AllHostProblems.name -notcontains $_.host_name} | Select-Object -Property host_name,name,status_text
            }
        else {
            $AllOpenServiceProblems | where {$AllHostProblems.name -notcontains $_.host_name}
            }
    }
    End
    {
    }
}