<#
.Synopsis
Enables Nagios global notifications.

.DESCRIPTION
This function is a shortcut to Invoke-Nagios to automatically choose
to enable nagios global notifications.

.EXAMPLE
Enable-NagiosGlobalNotification 

.EXAMPLE
Enable-NagiosGlobalNotification -Credential $Credential 

.EXAMPLE
Enable-NagiosGlobalNotification -Credential $Credential -NagiosCoreUrl https://nagiosdev.domain.com/nagios
#>
Function Enable-NagiosGlobalNotification {
    Param (
        # Nagios base url
        [Parameter(Mandatory = $false,  
            HelpMessage = "The base url of your nagios installation (i.e. http://nagios.domain.com/nagios)")]
        [string]$NagiosCoreUrl,

        # Nagios Credential
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCredential]$Credential

    )
    begin {}
    process {    
        Write-Verbose "Enabling Nagios global notifications"
        Invoke-NagiosRequest -Action 12 -Credential $Credential -NagiosCoreUrl $NagiosCoreUrl
    }
    end {}
}