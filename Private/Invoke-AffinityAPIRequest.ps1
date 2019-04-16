<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.INPUTS
   Inputs to this cmdlet (if any)
.OUTPUTS
   Output from this cmdlet (if any)
.NOTES
   General notes
#>
function Invoke-AffinityAPIRequest
{
    [CmdletBinding(PositionalBinding = $true,
                   HelpUri = 'https://api-docs.affinity.co')]
    [OutputType([System.Management.Automation.PSObject])]
    Param
    (
        # Affinity Credentials
        [Parameter(Mandatory = $false,
                   Position = 0)]
        [ValidateNotNullorEmpty()]
        [pscredential]
        $Credentials = $AffinityCredentials,

        # HTTP Method
        [Parameter(Mandatory = $false,
                   Position = 1)]
        [ValidateNotNullorEmpty()]
        [Microsoft.PowerShell.Commands.WebRequestMethod]
        $Method = [Microsoft.PowerShell.Commands.WebRequestMethod]::Get,

        # Affinity API Base URL
        [Parameter(Mandatory = $false,
                   Position = 2)]
        [ValidateNotNullOrEmpty()]
        [string]
        $AffinityBaseUrl = $AffinityStandardBaseUrl,

        # Affinity API URL fragment
        [Parameter(Mandatory = $true,
                   Position = 3)]
        [ValidateNotNullorEmpty()]
        [String]
        $Fragment,

        # Content
        [Parameter(Mandatory = $false,
                   Position = 4)]
        [Hashtable]
        $Content
    )

    Begin {
        # Strip username (Affinity currently accepts any username, PWSH will not accept a null or empty UserName)
        if ($Credentials.UserName) {
            $Credentials = New-Object System.Management.Automation.PSCredential -ArgumentList (
                [pscustomobject] @{
                    UserName = ' '
                    Password = $Credentials.Password
                }
            )
        }
    }
    Process {
        $IRMParameters = @{
            'Method'            = $Method
            'Uri'               = ("{0}/{1}" -f $AffinityBaseUrl, $Fragment)
            'Credential'        = $Credentials
        }

        if ($PSVersionTable.PSVersion.Major -ge 6 ) { $IRMParameters.Add( 'Authentication', 'Basic' ) }

        # Handle content
        if ($Content) {
            if (Test-NestedContainer $Content) {
                $IRMParameters.Add('Body'       ,   ($Content | ConvertTo-Json -Compress -Depth 10) )
                $IRMParameters.Add('ContentType',   'application/json'                              )
            }
            else {
                $IRMParameters.Add('Body'       ,   $Content                    )
            }
        }

        # Splat parameters
        Invoke-RestMethod @IRMParameters
    }
}
