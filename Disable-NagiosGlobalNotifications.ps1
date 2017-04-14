<#
.Synopsis
   Disables Nagios global notifications.
.DESCRIPTION
   This function is a shortcut to Invoke-Nagios to automatically choose
   to disable nagios global notifications.
.EXAMPLE
   Disable-NagiosGlobalNotifications 
.EXAMPLE
   Disable-NagiosGlobalNotifications -username jdoe
.EXAMPLE
   Disable-NagiosGlobalNotifications -username svcnagiosadmin -password Password!
.EXAMPLE
   Disable-NagiosGlobalNotifications -username svcnagiosadmin -password Password! -NagiosCoreUrl https://nagiosdev.domain.com/nagios
#>
Function Disable-NagiosGlobalNotifications {
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
            Write-Verbose "Disabling Nagios global notifications"
            Invoke-NagiosRequest -action 11 -username $username -password $password -NagiosCoreUrl $NagiosCoreUrl
        }
    end {}
    }