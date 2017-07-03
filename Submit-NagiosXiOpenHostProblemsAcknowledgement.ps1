<#
.SYNOPSIS
   Acknowldge all open host problems in Nagios XI.
.DESCRIPTION
   Get a list of open host problems from Nagios XI using Invoke-NagiosXiApi and then
   acknowledge each of them. 

   Open service problems are services in Nagios that are warning, critical, or unknown and that 
   have not been acknowledged on all servers including those that are up and not in a 
   scheduled down time.

   All parameters have default values, but you should change your NagiosXiApiUrl and NagiosXiApiKey to match
   your environment. See the documentation for Invoke-NagiosXiApi.
.PARAMETER Comment
   Provide a comment for the acknowledgement.
.EXAMPLE
   Submit-NagiosXiOpenHostProblemsAcknowledgement
#>
function Submit-NagiosXiOpenHostProblemsAcknowledgement {
    [CmdletBinding()]
    [Alias()]
    Param
    (
        [string]$NagiosXiApiUrl,
        [string]$NagiosXiApiKey,
        [string]$NagiosCoreUrl,
        [string]$Comment = 'Acknowledged by Mr. Automaton.'
    )

    Begin {}
    Process {
        Write-Verbose 'Getting Nagios XI open host problems.'
        
        $OpenHostProblems = Get-NagiosXiOpenHostProblem -NagiosXiApiUrl $NagiosXiApiUrl -NagiosXiApiKey $NagiosXiApiKey
        
        foreach ($OpenHostProblem in $OpenHostProblems) {
            Write-Verbose -Message "Submitting Nagios acknowledgement for $($OpenHostProblem.name)"
            Submit-NagiosHostAcknowledgement -ComputerName $OpenHostProblem.name -comment $Comment -NagiosCoreUrl $NagiosCoreUrl
        }
    }
    End {}
}