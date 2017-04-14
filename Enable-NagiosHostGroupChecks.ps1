﻿<#
.Synopsis
   Enables Nagios Host checks for a specified hostgroup.
.DESCRIPTION
   This function is a shortcut to Invoke-Nagios to automatically choose
   to enable nagios checks for a specified hostgroup.
.EXAMPLE
   Enable-NagiosHostGroupChecks -HostGroup HostgroupName
.EXAMPLE
   Enable-NagiosHostGrouptChecks -HostGroup HostgroupName -username jdoe
.EXAMPLE
   Enable-NagiosHostGroupChecks -HostGroup HostgroupName -username svcnagiosadmin -password Password!
.EXAMPLE
   Enable-NagiosHostGroupChecks -HostGroup HostgroupName -username svcnagiosadmin -password Password! -NagiosCoreUrl https://nagiosdev.domain.com/nagios
#>
Function Enable-NagiosHostGroupChecks {
    Param (
        # Nagios Host
        [Parameter(Mandatory=$true,
                    ValueFromPipeline=$true,
                    ValueFromPipelineByPropertyName=$true,
                    Position=0,
                    HelpMessage = "What nagios refers to host(s) for which you wish to enable/disable checks and notifications. Nagios is case-sensitive for hosts (i.e. server01 != SERVER01).")]
        [alias('host')]
        [string[]]$HostGroup,
        
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
        foreach ($hg in $HostGroup) {
            Write-Verbose "Enabling Nagios Hostgroup Checks for $hg"
            Invoke-NagiosRequest -hostgroup $hg -action 67 -username $username -password $password -NagiosCoreUrl $NagiosCoreUrl
            }
        }
    end {}
    }