<#
.SYNOPSIS
Enables Nagios Host checks for a specified host.

.DESCRIPTION
This function is a shortcut to Invoke-Nagios to automatically choose
to enable nagios checks for a specified host.

.EXAMPLE
Enable-NagiosHostCheck -ComputerName SERVER01

.EXAMPLE
Enable-NagiosHostCheck -ComputerName SERVER01 -Credential $Credential

.EXAMPLE
Enable-NagiosHostCheck -ComputerName SERVER01 -Credential $Credential -NagiosCoreUrl https://nagiosdev.domain.com/nagios
#>
Function Enable-NagiosHostCheck {
    Param (
        # Nagios Host
        [Parameter(Mandatory=$true,
                    ValueFromPipeline=$true,
                    ValueFromPipelineByPropertyName=$true,
                    Position=0,
                    HelpMessage = "What nagios refers to host(s) for which you wish to enable/disable checks and notifications. Nagios is case-sensitive for hosts (i.e. server01 != SERVER01)."
                    )]
        [alias('host')]
        [string[]]$ComputerName=$env:COMPUTERNAME,
        
        # Nagios base url
        [Parameter(Mandatory=$false,
        Position=2,
        HelpMessage="The base url of your nagios installation (i.e. http://nagios.domain.com/nagios)"
        )]
        [string]$NagiosCoreUrl,

        # Nagios Credential
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]$Credential
    )
    begin {}
    process {
        foreach ($Computer in $ComputerName) {
            Write-Verbose "Enabling Nagios Host Checks for $Computer"
            Invoke-NagiosRequest -ComputerName $Computer -action 15 -Credential $Credential -NagiosCoreUrl $NagiosCoreUrl
            }
        }
    end {}
    }