<#
.Synopsis
   Get a list of service status from Nagios XI.
.DESCRIPTION
   Get a list of service status from Nagios XI using Invoke-NagiosXiApi.
   

   All parameters have default values, but you should change your NagiosXiApiUrl and NagiosXiApiKey to match
   your environment. See the documentation for Invoke-NagiosXiApi.
.PARAMETER HostName
   Provide the name of a monitored service. You can also provide multiple host names. Additionally
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
function Get-NagiosXiServiceStatus
{
    [CmdletBinding()]
    [Alias()]
    Param
    (
        [string]$NagiosXiApiUrl,
        [string]$NagiosXiApiKey,
        [string]$Resource='objects/servicestatus',
        [string]$Method='Get',
        [string[]]$HostName,
        [string[]]$ServiceName,
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
                
                $Query = "host_name=in:"
                foreach ($Host in $HostName) {
                    $Query += "$Host,"
                    Write-Verbose "Query $Query"
                    }
                }
            else {
                $Query = "host_name=$HostName"
                Write-Verbose "Query $Query"
                }
            }
        else {
            Write-Verbose 'No host name entered.'
            $Query = $null
            Write-Verbose "Query $Query"
            }
        Write-Verbose "Query $Query"

        # Build ServiceName list into Query
        if ($ServiceName) {
            if ($ServiceName.Count -gt 1) {
                
                # More than one service name entered.
                Write-Verbose 'More than one service name entered.'
                $Query += "&name=in:"
                Write-Verbose "Query $Query"
                # Loop through each service name to add to query.
                foreach ($Service in $ServiceName) {
                    $Query += "$Service,"
                    Write-Verbose "Query $Query"
                    }
                }
            else {
                # Only one service name entered.
                Write-Verbose "Only one server named entered."
                $Query += "&name=$ServiceName" 
                Write-Verbose "Query $Query"
                }
            }
        else {
            # No service name entered
            Write-Verbose 'No Service name entered.'
            if (!$Query) {
                $Query = $null
                Write-Verbose "Query $Query"
                }
            else {
                Write-Verbose "Query $Query"
                }
            }
            

        Write-Verbose "Query $Query"
        $ServiceStatus = Invoke-NagiosXIApi -NagiosXiApiUrl $NagiosXiApiUrl -Resource $Resource -Method $Method -Query $Query -NagiosXiApiKey $NagiosXiApiKey
        
        if ($Summary) {
            $ServiceStatus.servicestatuslist.servicestatus | Select-Object -Property host_name,name,status_text
            }
        else {
            $ServiceStatus.servicestatuslist.servicestatus
            }
    }
    End
    {
    }
}