<#
.Synopsis
   Acknowledge all open service problems in Nagios XI.
.DESCRIPTION
   Get a list of open service problems from Nagios XI using Invoke-NagiosXiApi and then
   acknowledge each of them. 

   Open service problems are services in Nagios that are warning, critical, or unknown and that 
   have not been acknowledged on all servers including those that are up and not in a 
   scheduled down time.

   All parameters have default values, but you should change your NagiosXiApiUrl and NagiosXiApiKey to match
   your environment. See the documentation for Invoke-NagiosXiApi.
.PARAMETER Comment
   Provide a comment for the acknowledgement.
.EXAMPLE
   Submit-NagiosXiOpenServiceProblemsAcknowledgement
#>
function Submit-NagiosXiOpenServiceProblemsAcknowledgement
{
    [CmdletBinding()]
    [Alias()]
    Param
    (
        [string]$NagiosXiApiUrl,
        [string]$NagiosXiApiKey,
        [string]$NagiosCoreUrl,
        #[string]$ServiceName='*', # Maybe later we can add filtering by service name and/or by host name
        [string]$Comment = 'Acknowledged by Mr. Automaton.'
    )

    Begin
    {
        
    }
    Process
    {
        Write-Verbose 'Getting Nagios XI open service problems.'
        $AllOpenServiceProblems = Get-NagiosXIAllOpenServiceProblems -NagiosXiApiUrl $NagiosXiApiUrl -NagiosXiApiKey $NagiosXiApiKey
        $AllHostProblems = Get-NagiosXIAllHostProblems -NagiosXiApiUrl $NagiosXiApiUrl -NagiosXiApiKey $NagiosXiApiKey
        $OpenServiceProblems = $AllOpenServiceProblems | where {$AllHostProblems.name -notcontains $_.host_name}
        
        foreach ($OpenServiceProblem in $OpenServiceProblems) {
            Write-Verbose -Message "Submitting Nagios acknowledgement for $($OpenServiceProblem.name) on $($OpenServiceProblem.host_name)"
            Submit-NagiosServiceAcknowledgement -ComputerName $OpenServiceProblem.host_name -service $OpenServiceProblem.name -comment $Comment -NagiosCoreUrl $NagiosCoreUrl
            }
    }
    End
    {
    }
}