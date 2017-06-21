<#
.SYNOPSIS
Enables Nagios service notifications for a specified host.

.DESCRIPTION
This function is a shortcut to Invoke-Nagios to automatically choose
to enable nagios notifications for a specified service on a host.

.EXAMPLE
Enable-NagiosServiceNotifications -ComputerName SERVER01 -Service sqlserver

.EXAMPLE
Enable-NagiosServiceNotifications -ComputerName SERVER01 -Service sqlserver -Credential $Credential

.EXAMPLE
Enable-NagiosServiceNotifications -ComputerName SERVER01 -Service sqlserver -Credential $Credential -NagiosCoreUrl https://nagiosdev.domain.com/nagios
#>
Function Enable-NagiosServiceNotification {
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
        
        # Service name (Case-Sensitive)
        [Parameter(Mandatory = $false
            , Position = 1
            , HelpMessage = "Service name (case-sensitive)"
        )]
        [string]$Service,

        # Nagios base url
        [Parameter(
            HelpMessage = "The base url of your nagios installation (i.e. http://nagios.domain.com/nagios)"
        )]
        [string]$NagiosCoreUrl,

        # Nagios Credential
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]$Credential

    )
    begin {}
    process {    
        foreach ($Computer in $ComputerName) {
            Write-Verbose "Disabling Nagios service Notifications for $Service on $Computer"
            Invoke-NagiosRequest -ComputerName $Computer -Service $Service -action 22 -Credential $Credential -NagiosCoreUrl $url
        }
    }
    end {}
}