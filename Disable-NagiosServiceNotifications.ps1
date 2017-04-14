<#
.Synopsis
   Disables Nagios service notifications for a specified host.
.DESCRIPTION
   This function is a shortcut to Invoke-Nagios to automatically choose
   to disable nagios notifications for a specified service on a host.
.EXAMPLE
   Disable-NagiosServiceNotifications -ComputerName SERVER01 -Service sqlserver
.EXAMPLE
   Disable-NagiosServiceNotifications -ComputerName SERVER01 -Service sqlserver -username jdoe
.EXAMPLE
   Disable-NagiosServiceNotifications -ComputerName SERVER01 -Service sqlserver -username svcnagiosadmin -password Password!
.EXAMPLE
   Disable-NagiosServiceNotifications -ComputerName SERVER01 -Service sqlserver -username svcnagiosadmin -password Password! -NagiosCoreUrl https://nagiosdev.domain.com/nagios
#>
Function Disable-NagiosServiceNotifications {
    Param (
        # Nagios Host
        [Parameter(Mandatory=$true,
                    ValueFromPipeline=$true,
                    ValueFromPipelineByPropertyName=$true,
                    Position=0,
                    HelpMessage = "What nagios refers to host(s) for which you wish to enable/disable checks and notifications. Nagios is case-sensitive for hosts (i.e. server01 != SERVER01).")]
        [alias('host')]
        [string[]]$ComputerName=$env:COMPUTERNAME,

        # Service name (Case-Sensitive)
        [Parameter(Mandatory=$false,Position=1,HelpMessage="Service name (case-sensitive)")]
        [string]$Service,
        
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
            Write-Verbose "Disabling Nagios service Notifications for $Service on $Computer"
            Invoke-NagiosRequest -ComputerName $Computer -Service $Service -action 23 -username $username -password $password -NagiosCoreUrl $NagiosCoreUrl
            }
        }
    end {}
    }