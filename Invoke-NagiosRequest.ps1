<#
.Synopsis
   This script allows the user execute cgi commands to a Nagios site by using
   the Invoke-WebRequest cmdlet.
.DESCRIPTION
   The purpose of the script is to automate the process of disabling/enabling 
   nagios notifications and/or checks for Nagios hosts and their services.
   
   The script utilizes Invoke-WebRequest to post to the nagios cmd.cgi. 

   Paramaters: 
        $computername - what nagios refers to as host for which you wish to
        enable/disable checks and notifications. Hosts are case-sensitive.

        $action - integer of nagios cmd.cgi for the action you wish to take

            Disable checks of all services on this host
            $action=16

            Enable checks of all services on this host
            $action=15

            Disable notifications for all services on this host
            $action=29

            Enable notifications for all services on this host
            $action=28

            Acknowledge service problem
            $action=34

            Force service check
            $action=7

        $NagiosCoreUrl - the base url of your nagios installation (i.e. http://nagios.domain.com/nagios)

        $username - the htaccess username

        $password - the htaccess password

.NOTES    
    Author: Jason Wasser
    Modified: 5/19/2015
    Version: 1.8
    Currently the script only supports enabling/disabling of active checks and
    notifications.
    
    Changelog:
    version 1.8
        * Added Disable-NagiosServiceNotifications and Enable-NagiosServiceNotifications
        * Added Disable-NagiosGlobalNotifications and Enable-NagiosGlobalNotifications
    version 1.7
        * Added logic for hostgroups and service groups
    version 1.6
        * Converted to Functions and script module
    version 1.52
        * Added host problem acknowledgement.
    version 1.51
        * Added logic for user not entering a password.
    version 1.5
        * Added service problem acknowledgement.
        * Added force service check.
        * Added disabling/enabling service checks for host groups
        * Added disabling/enabling service checks for service groups.
    version 1.0
        * Initial re-write of Set-NagiosCLI.ps1 now using Invoke-WebRequest.

     
    Future developments could include scheduled downtimes.
    
    Known Issues:
        * To run the script as a scheduled task as a service account will require running 
        Internet Explorer once as the user.
    
.EXAMPLE
   .\Invoke-NagiosRequest.ps1 -computername server1 -action 29 -NagiosCoreUrl http://nagios.domain.com/nagios -username nagiosadmin
   This will disable notifications for all services on host server1 including the host.
.EXAMPLE
   .\Invoke-NagiosRequest.ps1 -computername server1 -action 28 -NagiosCoreUrl http://nagios.domain.com/nagios -username nagiosadmin
   This will enable notifications for all services on host server1 including the host.
.EXAMPLE
   .\Invoke-NagiosRequest.ps1 -computername server1 -action 16 -NagiosCoreUrl http://nagios.domain.com/nagios -username nagiosadmin
   This will disable checks for all services on host server1 including the host.
.EXAMPLE
   .\Invoke-NagiosRequest.ps1 -computername server1 -action 15 -NagiosCoreUrl http://nagios.domain.com/nagios -username nagiosadmin
   This will enable checks for all services on host server1 including the host.
.EXAMPLE
   .\Invoke-NagiosRequest.ps1 -computername (get-content c:\temp\computerlist.txt) -action 29 -NagiosCoreUrl http://nagios.domain.com/nagios -username nagiosadmin
   This will disable notifications for a list of computers found in the c:\temp\computerlist.txt file.

#>
#requires -version 3.0
Function Invoke-NagiosRequest {
    [CmdletBinding(DefaultParameterSetName='ByHost')]
    Param
    (
        # Nagios Host
        [Parameter(Mandatory=$false,
                    ValueFromPipeline=$true,
                    ValueFromPipelineByPropertyName=$true,
                    Position=0,
                    HelpMessage = "What nagios refers to host(s) for which you wish to enable/disable checks and notifications. 
                    Nagios is case-sensitive for hosts (i.e. server01 != SERVER01).",
                    ParameterSetName='ByHost')]
        [alias('host')]
        [string[]]$ComputerName,

        # Nagios cmd.cgi action by number
        [Parameter(Mandatory=$true,Position=1,
            HelpMessage = "Integer of nagios cmd.cgi for the action you wish to take

                Disable checks of all services on this host
                action=16

                Enable checks of all services on this host
                action=15

                Disable notifications for a service on this host
                action=23

                Enable notifications for a service on this host
                action=22

                Disable notifications for all services on this host
                action=29

                Enable notifications for all services on this host
                action=28
            
                Acknowledge host alert
                action=33
            
                Acknowledge service alert
                action=34
            
                Force service check
                action=7

                Disable checks of all services on host group
                action=68

                Enable checks of all services on host group
                action=67

                Disable checks of all services in a service group
                action=114

                Enable checks of all services in a service group
                action=113
                ")]
        [ValidateSet(7,11,12,15,16,22,23,28,29,33,34,67,68,113,114)]
        [int]$action,

        [Parameter(Mandatory=$false)]
        [string]$service,

        [Parameter(Mandatory=$false)]
        [string]$servicegroup,

        [Parameter(Mandatory=$false)]
        [string]$comment,

        [Parameter(Mandatory=$false)]
        [string]$hostgroup,

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

    Begin
    {
        # Function for making the actual CGI POST command.
        Function Submit-NagiosRequest {
            Param (
                [string]$NagiosObject
                )
            Write-Output "###########################################################################"
            Write-Output "Submitting cgi command to Nagios for $NagiosObject"
            $WebRequest = Invoke-WebRequest -Uri $uri -Credential $Credential -Body $formFields -Method POST -ContentType 'application/x-www-form-urlencoded'
        
            # If there was a problem with the hostname or other problem the errorMessage DIV field will be displayed. If not display the infoMessage of success.
            $Message = $WebRequest.ParsedHtml.getElementsByTagName("div") | Where-Object "classname" -Match "errorMessage|infoMessage" | select -ExpandProperty innerText
            if ($Message) {
                $Message 
                }     
            Write-Output "###########################################################################"
            }
        
        # Building URI for Nagios CGI
        $cgiurl="/cgi-bin/cmd.cgi"
        $uri = $NagiosCoreUrl + $cgiurl
        
        # Credential verification
        if (!$Credential) {
            $Credential = Get-UserLogin -username $username -Password $password
            }
    }

    Process
    {
        # Here we need to separate out the Nagios commands that potential 
        # loop through a list of nagios hosts for the enabling/disabling
        # of checks and notifications from the other commands such as host 
        # groups, service groups, acknowledgements, and future development.

        switch -Regex ($action) {
             # List of action integers that are not computer/host based
            "67|68" {
                foreach ($hg in $hostgroup) {
                    switch ($action) {
                        # Enable checks of all services on host group
                        67 {
                            if (!$hg) {
                                $hg = Read-Host "Please enter the hostgroup (case-sensitive)"
                                }
                            $formFields = @{cmd_typ=$action;hostgroup=$hg;ahas=$true;cmd_mod=2}
                            }
                        # Disable checks of all services on host group
                        68 {
                            if (!$hg) {
                                $hg = Read-Host "Please enter the hostgroup (case-sensitive)"
                                }
                            $formFields = @{cmd_typ=$action;hostgroup=$hg;ahas=$true;cmd_mod=2}
                            }
                        }
                        Submit-NagiosRequest -NagiosObject $hg
                    }
                }
            "^113$|^114$" {
                foreach ($sg in $servicegroup) {
                    switch ($action) {
                        # Enable checks of all services in a service group
                        113 {
                            if (!$sg) {
                                $sg = Read-Host "Please enter the service group (case-sensitive)"
                                }
                            $formFields = @{cmd_typ=$action;servicegroup=$sg;ahas=$false;cmd_mod=2}
                            }
                        # Disable checks of all services in a service group
                        114 {
                            if (!$sg) {
                                $sg = Read-Host "Please enter the service group (case-sensitive)"
                                }
                            $formFields = @{cmd_typ=$action;servicegroup=$sg;ahas=$false;cmd_mod=2}
                            }
                        }
                        Submit-NagiosRequest -NagiosObject $sg
                    }
                }
            "^11$|^12$" {
                    Write-Verbose "Enabling/Disabling Global Nagios Notifications"
                    $formFields = @{cmd_typ=$action;cmd_mod=2}
                    Submit-NagiosRequest -NagiosObject 'GlobalNotifications'
                }
            default {
                # For all other host/computer commands.
                if (!$ComputerName) {
                    $ComputerName = Read-Host "Please enter a Nagios host name (case-sensitive)"
                    }
                foreach ($computer in $ComputerName) {
                    $computer = $computer.ToUpper()
                    switch -Regex ($action) {
                        # Acknowledge Host Problesm
                        33 {
                            if (!$comment){
                                $comment = Read-Host "Please enter a comment for acknowledgement"
                                }
                            $formFields = @{cmd_typ=$action;host=$computer;service=$service;cmd_mod=2;com_data=$comment;sticky_ack=$true;send_notification=$true}
                            }
                        # Acknowledge Service Problem
                        34 {
                            if (!$service) {
                                $service = Read-Host "Please enter the service name (case-sensitive)"
                                }
                            if (!$comment){
                                $comment = Read-Host "Please enter a comment for acknowledgement"
                                }
                            $formFields = @{cmd_typ=$action;host=$computer;service=$service;cmd_mod=2;com_data=$comment;sticky_ack=$true;send_notification=$true}
                            }
                        # Force service check
                        7 {
                            if (!$service) {
                                $service = Read-Host "Please enter the service name (case-sensitive)"
                                }
                            $formFields = @{cmd_typ=$action;host=$computer;service=$service;cmd_mod=2;start_time=(Get-Date -Format "MM-dd-yyyy HH:mm:ss");force_check=$true}
                            }
                        "22|23" {
                            if (!$service) {
                                $service = Read-Host "Please enter the service name (case-sensitive)"
                                }
                            $formFields = @{cmd_typ=$action;host=$computer;service=$service;cmd_mod=2}
                            }
                
                        # All other commands for enabling/disabling checks or notifications for hosts
                        default {
                            $formFields = @{cmd_typ=$action;host=$computer;ahas=$true;cmd_mod=2}
                            }
                        }
                    Submit-NagiosRequest -NagiosObject $computer
                    }
                }
            }
        }
    End
    {
    }
}
# End of Invoke-NagiosRequest Function
########################################################################################################