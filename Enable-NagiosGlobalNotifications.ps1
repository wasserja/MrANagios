<#
.Synopsis
   Enables Nagios global notifications.
.DESCRIPTION
   This function is a shortcut to Invoke-Nagios to automatically choose
   to enable nagios global notifications.
.EXAMPLE
   Enable-NagiosGlobalNotifications 
.EXAMPLE
   Enable-NagiosGlobalNotifications -username jdoe
.EXAMPLE
   Enable-NagiosGlobalNotifications -username svcnagiosadmin -password Password!
.EXAMPLE
   Enable-NagiosGlobalNotifications -username svcnagiosadmin -password Password! -NagiosCoreUrl https://nagiosdev.domain.com/nagios
#>
Function Enable-NagiosGlobalNotifications {
    Param (
        # Nagios base url
        [Parameter(Mandatory=$false,Position=2,HelpMessage="The base url of your nagios installation (i.e. http://nagios.domain.com/nagios)")]
        [string]$NagiosCoreUrl,

        # Nagios username
        [Parameter(Mandatory=$false,Position=3)]
        [string]$username,

        # Nagios password
        [Parameter(Mandatory=$false,Position=4)]
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
            Write-Verbose "Enabling Nagios global notifications"
            Invoke-NagiosRequest -action 12 -username $username -password $password -NagiosCoreUrl $NagiosCoreUrl
        }
    end {}
    }