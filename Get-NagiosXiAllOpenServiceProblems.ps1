<#
.SYNOPSIS
Get a list of all open service problems from Nagios XI.
.DESCRIPTION
Get a list of all open service problems from Nagios XI using Invoke-NagiosXiApi.
All open service problems are services in Nagios that are warning, critical, or unknown and that 
have not been acknowledged on all servers including those that are down, unreachable, or in 
scheduled down time.

All parameters have default values, but you should change your NagiosXiApiUrl and NagiosXiApiKey to match
your environment. See the documentation for Invoke-NagiosXiApi.
.EXAMPLE
Get-NagiosXiAllOpenServiceProblems

@attributes                 : @{id=822571}
instance_id                 : 1
service_id                  : 2561
host_id                     : 2558
host_name                   : SERVER10
host_alias                  : SERVER10
name                        : HP Hardware
host_display_name           : 
host_address                : SERVER10
display_name                : HP Hardware
status_update_time          : 2017-04-11 09:58:36
status_text                 : Compaq/HP Agent Check: ERROR: No snmp response from SERVER10 (alarm)
status_text_long            : 
current_state               : 3
performance_data            : 
should_be_scheduled         : 1
check_type                  : 0
last_state_change           : 2017-04-11 09:51:11
last_hard_state_change      : 2017-04-11 09:52:10
last_hard_state             : 3
last_time_ok                : 2017-04-11 09:51:11
last_time_warning           : 1969-12-31 19:00:00
last_time_critical          : 1969-12-31 19:00:00
last_time_unknown           : 2017-04-11 09:58:06
last_notification           : 1969-12-31 19:00:00
next_notification           : 1969-12-31 19:00:00
no_more_notifications       : 0
acknowledgement_type        : 0
current_notification_number : 0
process_performance_data    : 1
obsess_over_service         : 1
event_handler_enabled       : 1
modified_service_attributes : 2
event_handler               : 
check_command               : check_hp_hardware!snmpcommunityname!2!30!!!!!
normal_check_interval       : 3
retry_check_interval        : 1
check_timeperiod_id         : 126
icon_image                  : 
icon_image_alt              : 
has_been_checked            : 1
current_check_attempt       : 2
max_check_attempts          : 2
last_check                  : 2017-04-11 09:58:06
next_check                  : 2017-04-11 10:01:06
state_type                  : 1
notifications_enabled       : 1
problem_acknowledged        : 0
flap_detection_enabled      : 1
is_flapping                 : 1
percent_state_change        : 32.30263
latency                     : 0
execution_time              : 30.06112
scheduled_downtime_depth    : 0
passive_checks_enabled      : 1
active_checks_enabled       : 1

Get the list of open service problems.
#>
function Get-NagiosXiAllOpenServiceProblems {
    [CmdletBinding()]
    [Alias()]
    Param
    (
        [string]$NagiosXiApiUrl,
        [string]$NagiosXiApiKey,
        [string]$Resource = 'objects/servicestatus',
        [string]$Method = 'Get',
        [string]$Query = 'current_state=in:1,2,3&problem_acknowledged=0',
        [switch]$Summary
    )

    Begin {}
    Process {
        
        Write-Verbose 'Getting all open Nagios XI service problems.'
        $AllOpenServiceProblems = Invoke-NagiosXIApi -NagiosXiApiUrl $NagiosXiApiUrl -Resource $Resource -Method $Method -Query $Query -NagiosXiApiKey $NagiosXiApiKey
        if ($Summary) {
            Write-Verbose 'Summary Output selected.'
            $AllOpenServiceProblems.servicestatus| Select-Object -Property host_name, name, status_text
        }
        else {
            $AllOpenServiceProblems.servicestatus
        }
    }
    End {}
}