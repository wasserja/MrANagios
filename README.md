# MrANagios
Nagios PowerShell Module

The MrANagios PowerShell module is a collection of functions to automate actions on Nagios XI and Nagios Core. 

<pre>
PS C:\> Get-Command -Module MrANagios

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Function        Disable-NagiosGlobalNotification                   1.3.3        MrANagios
Function        Disable-NagiosHostCheck                            1.3.3        MrANagios
Function        Disable-NagiosHostGroupCheck                       1.3.3        MrANagios
Function        Disable-NagiosHostNotification                     1.3.3        MrANagios
Function        Disable-NagiosServiceGroupCheck                    1.3.3        MrANagios
Function        Disable-NagiosServiceNotification                  1.3.3        MrANagios
Function        Enable-NagiosGlobalNotification                    1.3.3        MrANagios
Function        Enable-NagiosHostCheck                             1.3.3        MrANagios
Function        Enable-NagiosHostGroupCheck                        1.3.3        MrANagios
Function        Enable-NagiosHostNotification                      1.3.3        MrANagios
Function        Enable-NagiosServiceGroupCheck                     1.3.3        MrANagios
Function        Enable-NagiosServiceNotification                   1.3.3        MrANagios
Function        Get-NagiosXiAllHostProblems                        1.3.3        MrANagios
Function        Get-NagiosXiAllOpenServiceProblems                 1.3.3        MrANagios
Function        Get-NagiosXiAllServiceProblems                     1.3.3        MrANagios
Function        Get-NagiosXiHostStatus                             1.3.3        MrANagios
Function        Get-NagiosXiOpenHostProblem                        1.3.3        MrANagios
Function        Get-NagiosXiOpenServiceProblem                     1.3.3        MrANagios
Function        Get-NagiosXiServiceStatus                          1.3.3        MrANagios
Function        Invoke-NagiosRequest                               1.3.3        MrANagios
Function        Invoke-NagiosXiApi                                 1.3.3        MrANagios
Function        Submit-NagiosHostAcknowledgement                   1.3.3        MrANagios
Function        Submit-NagiosServiceAcknowledgement                1.3.3        MrANagios
Function        Submit-NagiosXiOpenHostProblemsAcknowledgement     1.3.3        MrANagios
Function        Submit-NagiosXiOpenServiceProblemsAcknowledgement  1.3.3        MrANagios
</pre>

# Default Parameters
Optionally you can make your life easier by changing the default parameter values in the MrANagios.psm1 script module file (Lines 7-9) and then reload the module.

<pre>Import-Module MrANagios -Force</pre>

# Full Automation
The MrANagios module can utilize the MrACredential module to load an encrypted credential file from disk to completely automate the MrANagios functions.

Create an account in Nagios XI or Nagios that has the appropriate access to perform the automated commands you wish to execute. If you're using Nagios XI grab the API key for the account and put it in the MrANagios.psm1 (currently line 8).

Install the MrACredential PowerShell module.

<pre>Install-Module MrACredential</pre>

Generate a new encryption key, and save it to C:\Keys\NagiosLogon.key.

<pre>
New-EncryptionKey | Out-File C:\Keys\NagiosLogon.key
</pre>

Lock down the key file using NTFS permissions to only the accounts or groups that should be able to use the account.

Save the Nagios account credential to disk using the encryption key you just made.

<pre>
Save-Credential -CredentialFilePath C:\Credentials\NagiosLogon.xml -EncryptionKeyPath C:\Keys\NagiosLogon.key
</pre>

Once these two files are saved to disk and secured you can reload the module and enjoy automated Nagios operation from the comfort of your PowerShell console.

# Task Scheduler and Service Accounts
If you wish to implement automated Nagios operations via task scheduler and/or service accounts you may run into an error:

<pre>
Invoke-WebRequest : The response content cannot be parsed because the Internet Explorer engine is not available, or Internet Explorer’s first-launch configuration is not complete. Specify the UseBasicParsing parameter and try again.
</pre>

Workaround 1: Launch Internet Explorer once as the user account.

Workaround 2: [Prevent running First Run Wizard using group policy](http://wahlnetwork.com/2015/11/17/solving-the-first-launch-configuration-error-with-powershells-invoke-webrequest-cmdlet/) for your service accounts. 