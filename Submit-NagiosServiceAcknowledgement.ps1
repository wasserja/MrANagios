<#
.SYNOPSIS
   Acknowledge Nagios service problem for a specified host.

.DESCRIPTION
   This function is a shortcut to Invoke-Nagios to automatically choose
   to acknowledge nagios service problem for a specified host.

.EXAMPLE
   Submit-NagiosServiceAcknowledgement -ComputerName SERVER01 -service Uptime

.EXAMPLE
   Submit-NagiosServiceAcknowledgement -ComputerName SERVER01 -service Uptime -Credential $Credential

.EXAMPLE
   Submit-NagiosServiceAcknowledgement -ComputerName SERVER01 -service Uptime -Credential $Credential -NagiosCoreUrl https://nagiosdev.domain.com/nagios
#>
Function Submit-NagiosServiceAcknowledgement {
    Param (
        # Nagios Host
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0,
            HelpMessage = "What nagios refers to host(s) for which you wish to enable/disable checks and notifications. Nagios is case-sensitive for hosts (i.e. server01 != SERVER01)."
        )]
        [alias('host')]
        [string[]]$ComputerName = $env:COMPUTERNAME,

        [Parameter(Mandatory = $false, Position = 1)]
        [string]$Service,

        [Parameter(Mandatory = $false, Position = 2)]
        [string]$Comment,
        
        # Nagios base url
        [Parameter(
            HelpMessage = "The base url of your nagios installation (i.e. http://nagios.domain.com/nagios)")]
        [string]$NagiosCoreUrl,

        # Nagios Credential
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]$Credential

    )
    begin {}
    process {
        foreach ($Computer in $ComputerName) {
            Write-Verbose "Submitting acknowledgement for $service on $Computer"
            Invoke-NagiosRequest -ComputerName $Computer -action 34 -service $service -username $username -password $password -NagiosCoreUrl $NagiosCoreUrl -comment $comment
        }
    }
    end {}
}