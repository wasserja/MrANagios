<#
.Synopsis
   Enables Nagios services checks for a specified servicegroup.
.DESCRIPTION
   This function is a shortcut to Invoke-Nagios to automatically choose
   to enable nagios checks for a specified servicegroup.
.EXAMPLE
   Enable-NagiosServiceGroupChecks -ServiceGroup ServiceGroupName
.EXAMPLE
   Enable-NagiosServiceGroupChecks -ServiceGroup ServiceGroupName -username jdoe
.EXAMPLE
   Enable-NagiosServiceGroupChecks -ServiceGroup ServiceGroupName -username svcnagiosadmin -password Password!
.EXAMPLE
   Enable-NagiosServiceGroupChecks -ServiceGroup ServiceGroupName -username svcnagiosadmin -password Password! -NagiosCoreUrl https://nagiosdev.domain.com/nagios
#>
Function Enable-NagiosServiceGroupChecks {
    Param (
        # Nagios Host
        [Parameter(Mandatory=$true,
                    ValueFromPipeline=$true,
                    ValueFromPipelineByPropertyName=$true,
                    Position=0,
                    HelpMessage = "What nagios refers to service group(s) for which you wish to enable/disable checks and notifications. Nagios is case-sensitive for hosts (i.e. server01 != SERVER01).")]
        [alias('sg')]
        [string[]]$ServiceGroup,
        
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
        foreach ($sg in $ServiceGroup) {
            Write-Verbose "Enabling Nagios service group checks for $sg"
            Invoke-NagiosRequest -ServiceGroup $sg -action 113 -username $username -password $password -NagiosCoreUrl $NagiosCoreUrl
            }
        }
    end {}
    }