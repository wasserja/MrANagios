<#
.SYNOPSIS
Enables Nagios Host checks for a specified hostgroup.

.DESCRIPTION
This function is a shortcut to Invoke-Nagios to automatically choose
to enable nagios checks for a specified hostgroup.

.EXAMPLE
Enable-NagiosHostGroupCheck -HostGroup HostgroupName

.EXAMPLE
Enable-NagiosHostGroupCheck -HostGroup HostgroupName -Credential $Credential

.EXAMPLE
Enable-NagiosHostGroupCheck -HostGroup HostgroupName -Credential $Credential -NagiosCoreUrl https://nagiosdev.domain.com/nagios
#>
Function Enable-NagiosHostGroupCheck {
    Param (
        # Nagios Host
        [Parameter(Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            Position = 0,
            HelpMessage = "What nagios refers to host(s) for which you wish to enable/disable checks and notifications. Nagios is case-sensitive for hosts (i.e. server01 != SERVER01).")]
        [alias('host')]
        [string[]]$HostGroup,
        
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
        foreach ($hg in $HostGroup) {
            Write-Verbose "Enabling Nagios Hostgroup Checks for $hg"
            Invoke-NagiosRequest -hostgroup $hg -action 67 -Credential $Credential -NagiosCoreUrl $NagiosCoreUrl
        }
    }
    end {}
}