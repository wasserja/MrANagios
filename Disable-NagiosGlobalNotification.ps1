<#
.SYNOPSIS
Disables Nagios global notifications.

.DESCRIPTION
This function is a shortcut to Invoke-Nagios to automatically choose
to disable nagios global notifications.

.EXAMPLE
Disable-NagiosGlobalNotification 

.EXAMPLE
Disable-NagiosGlobalNotification -Credential $Credential

.EXAMPLE
Disable-NagiosGlobalNotification -Credential $Credential -NagiosCoreUrl https://nagiosdev.domain.com/nagios
#>
Function Disable-NagiosGlobalNotification {
    Param (
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
        Write-Verbose "Disabling Nagios global notifications"
        Invoke-NagiosRequest -action 11 -username $username -password $password -NagiosCoreUrl $NagiosCoreUrl
    }
    end {}
}