<#
.SYNOPSIS
Enables Nagios services checks for a specified servicegroup.

.DESCRIPTION
This function is a shortcut to Invoke-Nagios to automatically choose
to enable nagios checks for a specified servicegroup.

.EXAMPLE
Enable-NagiosServiceGroupChecks -ServiceGroup ServiceGroupName

.EXAMPLE
Enable-NagiosServiceGroupChecks -ServiceGroup ServiceGroupName -Credential $Credential

.EXAMPLE
Enable-NagiosServiceGroupChecks -ServiceGroup ServiceGroupName -Credential $Credential -NagiosCoreUrl https://nagiosdev.domain.com/nagios
#>
Function Enable-NagiosServiceGroupCheck {
    Param (
        # Nagios Host
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0,
            HelpMessage = "What nagios refers to service group(s) for which you wish to enable/disable checks and notifications. Nagios is case-sensitive for hosts (i.e. server01 != SERVER01)."
        )]
        [alias('sg')]
        [string[]]$ServiceGroup,
        
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
        foreach ($sg in $ServiceGroup) {
            Write-Verbose "Enabling Nagios service group checks for $sg"
            Invoke-NagiosRequest -ServiceGroup $sg -action 113 -Credential $Credential -NagiosCoreUrl $NagiosCoreUrl
        }
    }
    end {}
}