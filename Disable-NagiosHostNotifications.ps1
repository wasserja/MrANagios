<#
.Synopsis
   Disables Nagios Host notifications for a specified host.
.DESCRIPTION
   This function is a shortcut to Invoke-Nagios to automatically choose
   to disable nagios notifications for a specified host.
.EXAMPLE
   Disable-NagiosHostNotifications -ComputerName SERVER01
.EXAMPLE
   Disable-NagiosHostNotifications -ComputerName SERVER01 -username jdoe
.EXAMPLE
   Disable-NagiosHostNotifications -ComputerName SERVER01 -username svcnagiosadmin -password Password!
.EXAMPLE
   Disable-NagiosHostNotifications -ComputerName SERVER01 -username svcnagiosadmin -password Password! -NagiosCoreUrl https://nagiosdev.domain.com/nagios
#>
Function Disable-NagiosHostNotifications {
    Param (
        # Nagios Host
        [Parameter(Mandatory=$true,
                    ValueFromPipeline=$true,
                    ValueFromPipelineByPropertyName=$true,
                    Position=0,
                    HelpMessage = "What nagios refers to host(s) for which you wish to enable/disable checks and notifications. Nagios is case-sensitive for hosts (i.e. server01 != SERVER01).")]
        [alias('host')]
        [string[]]$ComputerName=$env:COMPUTERNAME,
        
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
        foreach ($Computer in $ComputerName) {
            Write-Verbose "Disabling Nagios Host Notifications for $Computer"
            Invoke-NagiosRequest -ComputerName $Computer -action 29 -username $username -password $password -NagiosCoreUrl $NagiosCoreUrl
            }
        }
    end {}
    }