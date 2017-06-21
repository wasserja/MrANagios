<#
.SYNOPSIS
Get a list of open host problems from Nagios XI.
.DESCRIPTION
Get a list of open host problems from Nagios XI using Invoke-NagiosXiApi.
All host problems are hosts in Nagios that are down, unreachable, or unknown.

All parameters have default values, but you should change your NagiosXiApiUrl and NagiosXiApiKey to match
your environment. See the documentation for Invoke-NagiosXiApi.

.EXAMPLE
   Get-NagiosXiOpenHostProblems

@attributes                 : @{id=118527}
instance_id                 : 1
host_id                     : 8937
name                        : SERVER10
display_name                : SERVER10
address                     : SERVER10
alias                       : SERVER10
status_update_time          : 2017-04-11 09:44:17
status_text                 : check_icmp: Failed to resolve SERVER10
status_text_long            : 
current_state               : 1
icon_image                  : 
icon_image_alt              : 
performance_data            : 
should_be_scheduled         : 1
check_type                  : 0
last_state_change           : 2017-04-10 08:29:55
last_hard_state_change      : 2017-04-10 08:29:55
last_hard_state             : 1
last_time_up                : 2017-02-27 16:38:24
last_time_down              : 2017-04-11 09:44:17
last_time_unreachable       : 2017-04-10 08:29:55
last_notification           : 1969-12-31 19:00:00
next_notification           : 1969-12-31 19:00:00
no_more_notifications       : 0
acknowledgement_type        : 2
current_notification_number : 1
event_handler_enabled       : 1
process_performance_data    : 1
obsess_over_host            : 1
modified_host_attributes    : 0
event_handler               : 
check_command               : check-host-alive!!!!!!!!
normal_check_interval       : 3
retry_check_interval        : 1
check_timeperiod_id         : 126
has_been_checked            : 1
current_check_attempt       : 2
max_check_attempts          : 2
last_check                  : 2017-04-11 09:44:17
next_check                  : 2017-04-11 09:47:17
state_type                  : 1
notifications_enabled       : 1
problem_acknowledged        : 1
passive_checks_enabled      : 1
active_checks_enabled       : 1
flap_detection_enabled      : 1
is_flapping                 : 0
percent_state_change        : 0
latency                     : 0
execution_time              : 0.00165
scheduled_downtime_depth    : 0

Returns a list of hosts that are down, unreachable, or unknown.
#>
function Get-NagiosXiOpenHostProblem {
    [CmdletBinding()]
    [Alias()]
    Param
    (
        [string]$NagiosXiApiUrl,
        [string]$NagiosXiApiKey,
        [string]$Resource = 'objects/hoststatus',
        [string]$Method = 'Get',
        [string]$Query = 'current_state=in:1,2,3&problem_acknowledged=0',
        [switch]$Summary
    )

    Begin {}
    Process {
        
        Write-Verbose 'Getting all Nagios XI host problems.'
        $OpenHostProblems = Invoke-NagiosXIApi -NagiosXiApiUrl $NagiosXiApiUrl -Resource $Resource -Method $Method -Query $Query -NagiosXiApiKey $NagiosXiApiKey
        if ($Summary) {
            $OpenHostProblems.hoststatuslist.hoststatus | Select-Object -Property name, status_text, last_check
        }
        else {
            $OpenHostProblems.hoststatuslist.hoststatus
        }
    }
    End {}
}