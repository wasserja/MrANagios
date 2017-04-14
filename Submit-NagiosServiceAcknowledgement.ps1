<#
.Synopsis
   Acknowledge Nagios service problem for a specified host.
.DESCRIPTION
   This function is a shortcut to Invoke-Nagios to automatically choose
   to acknowledge nagios service problem for a specified host.
.EXAMPLE
   Submit-NagiosServiceAcknowledgement -ComputerName SERVER01 -service Uptime
.EXAMPLE
   Submit-NagiosServiceAcknowledgement -ComputerName SERVER01 -service Uptime -username jdoe
.EXAMPLE
   Submit-NagiosServiceAcknowledgement -ComputerName SERVER01 -service Uptime -username svcnagiosadmin -password Password!
.EXAMPLE
   Submit-NagiosServiceAcknowledgement -ComputerName SERVER01 -service Uptime -username svcnagiosadmin -password Password! -NagiosCoreUrl https://nagiosdev.domain.com/nagios
#>
Function Submit-NagiosServiceAcknowledgement {
    Param (
        # Nagios Host
        [Parameter(Mandatory=$true,
                    ValueFromPipeline=$true,
                    ValueFromPipelineByPropertyName=$true,
                    Position=0,
                    HelpMessage = "What nagios refers to host(s) for which you wish to enable/disable checks and notifications. Nagios is case-sensitive for hosts (i.e. server01 != SERVER01).")]
        [alias('host')]
        [string[]]$ComputerName=$env:COMPUTERNAME,

        [Parameter(Mandatory=$false,Position=1)]
        [string]$service,

        [Parameter(Mandatory=$false,Position=2)]
        [string]$comment,
        
        # Nagios base url
        [Parameter(Mandatory=$false,Position=3,HelpMessage="The base url of your nagios installation (i.e. http://nagios.domain.com/nagios)")]
        [string]$NagiosCoreUrl,

        # Nagios username
        [Parameter(Mandatory=$false,Position=4)]
        [string]$username,

        # Nagios password
        [Parameter(Mandatory=$false,Position=5)]
        [string]$password

    )
    begin {
        if (!$Credential) {
            $Credential = Get-UserLogin -username $username -Password $password
            }
        else {
            Write-Verbose 'Credential Object already supplied.'
            }
        }
    process {
        foreach ($Computer in $ComputerName) {
            Write-Verbose "Submitting acknowledgement for $service on $Computer"
            Invoke-NagiosRequest -ComputerName $Computer -action 34 -service $service -username $username -password $password -NagiosCoreUrl $NagiosCoreUrl -comment $comment
            }
        }
    end {}
    }