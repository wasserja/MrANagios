<#
.Synopsis
   Get a list of host status from Nagios XI.
.DESCRIPTION
   Get a list of host status from Nagios XI using Invoke-NagiosXiApi.
   

   All parameters have default values, but you should change your NagiosXiApiUrl and NagiosXiApiKey to match
   your environment. See the documentation for Invoke-NagiosXiApi.
.PARAMETER HostName
   Provide the name of a monitored host. You can also provide multiple host names. Additionally
   you can use a matching keyword "lk" to search for hosts matching a specific string.
.EXAMPLE
   Get-NagiosXiHostStatus

   Returns the status for all hosts in Nagios.
.EXAMPLE
   Get-NagiosXiHostStatus -HostName SERVER01
   
   Returns the host status for server named server01.
.EXAMPLE
   Get-NagiosXiHostStatus -HostName SERVER01,SERVER02

   Returns the host status for server named server01 and server02.
.EXAMPLE
   Get-NagiosXiHostStatus -Query 'lk:server'

   Returns the host status for any Nagios hosts with the string server in the name.
#>
function Get-NagiosXiHostStatus
{
    [CmdletBinding()]
    [Alias()]
    Param
    (
        [string]$NagiosXiApiUrl,
        [string]$NagiosXiApiKey,
        [string]$Resource='objects/hoststatus',
        [string]$Method='Get',
        [string[]]$HostName,
        [switch]$Summary
    )

    Begin
    {
        
    }
    Process
    {
        
        # Build Hostname list into Query
        if ($HostName) {
            if ($HostName.Count -gt 1) {
                
                $Query = "name=in:"
                foreach ($Host in $HostName) {
                    $Query += "$Host,"
                    }
                }
            else {
                $Query = "name=$HostName"
                }
            }
        else {
            $Query = $null
            }   
        Write-Verbose "Query $Query"
        $HostStatus = Invoke-NagiosXIApi -NagiosXiApiUrl $NagiosXiApiUrl -Resource $Resource -Method $Method -Query $Query -NagiosXiApiKey $NagiosXiApiKey
        if ($Summary) {
            $HostStatus.hoststatuslist.hoststatus | Select-Object -Property name,status_text,last_check
            }
        else {
            $HostStatus.hoststatuslist.hoststatus
            }
        
    }
    End
    {
    }
}