# encrypt the credentials into a Credential object for use with Invoke-WebRequest.
Function Encrypt-Password {
    param (
        # Nagios username
        [Parameter(Mandatory=$false,Position=0)]
        [string]$username,
        [Parameter(ValueFromPipeline=$true,Mandatory=$false,Position=1)]
        [String]$Password
        )

    begin {}
    process {
        $securepassword = ConvertTo-SecureString -String $password -AsPlainText -Force
        $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username,$securepassword
        $Credential
        }
    end {}
    }