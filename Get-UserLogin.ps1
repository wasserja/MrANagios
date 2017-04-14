Function Get-UserLogin {
    param (
        # Nagios username
        [Parameter(Mandatory=$false,Position=0)]
        [string]$username,
        # Nagios password
        [Parameter(Mandatory=$false,Position=1)]
        [string]$Password
        )

    begin {}
    process {    
        # Verifying if a username and/or password was entered.
        # If no username was entered, we can assume no password was entered.
        
        if (!$username) {
            $Credential = Get-Credential -ErrorAction Stop
            if (!$Credential) {
                Write-Error "No password was entered. Exiting."
                break
                }
            else {
                return $Credential
                }
            }
        else {
            # If a username was supplied but no password, prompt for it.
            if (!$password) {
                $Credential = Get-Credential -Credential $username -ErrorAction Stop
                if (!$Credential) {
                    Write-Error "No password was entered. Exiting."
                    break
                    }
                else {
                    return $Credential
                    }
                }
            else {
                $Credential = Encrypt-Password -username $username -Password $password
                return $Credential
                }
            }
        
        # End of username/password section
        }
    end {}
    }