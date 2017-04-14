<#
.Synopsis
   Get a list of all service problems from Nagios XI.
.DESCRIPTION
   Get a list of all service problems from Nagios XI using Invoke-NagiosXiApi.
   All service problems are services in Nagios that are warning, critical, or unknown.

   All parameters have default values, but you should change your NagiosXiApiUrl and NagiosXiApiKey to match
   your environment. See the documentation for Invoke-NagiosXiApi.
.EXAMPLE
   Get-NagiosXiAllServiceProblems

@attributes                 : @{id=823198}
instance_id                 : 1
service_id                  : 5944
host_id                     : 5940
host_name                   : SERVER10
host_alias                  : SERVER10
name                        : automatic-services
host_display_name           : 
host_address                : SERVER10
display_name                : automatic-services
status_update_time          : 2017-04-11 09:49:29
status_text                 : CRITICAL: CertSvc: stopped (critical)
status_text_long            : 
current_state               : 2
performance_data            : 
should_be_scheduled         : 1
check_type                  : 0
last_state_change           : 2017-02-21 16:19:57
last_hard_state_change      : 2017-02-21 16:20:57
last_hard_state             : 2
last_time_ok                : 2017-02-21 16:19:57
last_time_warning           : 1969-12-31 19:00:00
last_time_critical          : 2017-04-11 09:49:29
last_time_unknown           : 1969-12-31 19:00:00
last_notification           : 2017-02-21 16:20:57
next_notification           : 2017-02-21 16:23:57
no_more_notifications       : 0
acknowledgement_type        : 1
current_notification_number : 1
process_performance_data    : 1
obsess_over_service         : 1
event_handler_enabled       : 1
modified_service_attributes : 2
event_handler               : 
check_command               : check_nrpe!CheckServiceState -a CheckAll exclude=ShellHWDetection exclude=ccmsetup exclude=wuauserv exclude=RemoteRegistry exclude=clr_optimization_v4.0.30319_32 exclude=clr_optimization_v4.0.30319_64 exclude=SysmonLog 
                              exclude=spp
normal_check_interval       : 3
retry_check_interval        : 1
check_timeperiod_id         : 126
icon_image                  : 
icon_image_alt              : 
has_been_checked            : 1
current_check_attempt       : 2
max_check_attempts          : 2
last_check                  : 2017-04-11 09:49:29
next_check                  : 2017-04-11 09:52:29
state_type                  : 1
notifications_enabled       : 1
problem_acknowledged        : 1
flap_detection_enabled      : 1
is_flapping                 : 0
percent_state_change        : 0
latency                     : 0
execution_time              : 0.02934
scheduled_downtime_depth    : 0
passive_checks_enabled      : 1
active_checks_enabled       : 1

Returns a list of all service problems.

#>
function Get-NagiosXiAllServiceProblems
{
    [CmdletBinding()]
    [Alias()]
    Param
    (
        [string]$NagiosXiApiUrl,
        [string]$NagiosXiApiKey,
        [string]$Resource='objects/servicestatus',
        [string]$Method='Get',
        [string]$Query='current_state=in:1,2,3',
        [switch]$Summary
    )

    Begin
    {
        
    }
    Process
    {
        
        Write-Verbose 'Getting all Nagios XI service problems.'
        $AllServiceProblems = Invoke-NagiosXIApi -NagiosXiApiUrl $NagiosXiApiUrl -Resource $Resource -Method $Method -Query $Query -NagiosXiApiKey $NagiosXiApiKey
        if ($Summary) {
            $AllServiceProblems.servicestatuslist.servicestatus | Select-Object -Property host_name,name,status_text
            }
        else {
            $AllServiceProblems.servicestatuslist.servicestatus
            }
        
    }
    End
    {
    }
}