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
.LINK
    https://api-docs.affinity.co
#>
function Invoke-AffinityAPIRequest
{
    [CmdletBinding(PositionalBinding = $true)]
    [OutputType([System.Management.Automation.PSObject])]
    Param
    (
        # Affinity Credentials
        [Parameter(Mandatory = $false,
                   Position = 0)]
        [ValidateNotNullorEmpty()]
        $Credentials = ( Get-AffinitySetting -Credentials ),

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
        $BaseUrl = ( Get-AffinitySetting -BaseUrl ),

        # Affinity API URL fragment
        [Parameter(Mandatory = $true,
                   Position = 3)]
        [ValidateNotNullorEmpty()]
        [string]
        $Fragment,

        # Content
        [Parameter(Mandatory = $false,
                   Position = 4)]
        [hashtable]
        $Content
    )

    Begin {
        switch ($AffinitySettingObjectType) {
            'Credential' {
                # Strip username (Affinity currently accepts any username, PWSH will only accept a null  or empty
                # UserName in PWSH v7.0+)
                if ($Credentials.UserName) {
                    $Credentials = New-Object System.Management.Automation.PSCredential -ArgumentList (
                        [pscustomobject] @{
                            UserName = ' '
                            Password = $Credentials.Password
                        }
                    )
                }

                $IRMParameters = @{'Credential' = $Credentials}
                if ($PSVersionTable.PSVersion.Major -ge 6) { $IRMParameters.Add('Authentication', 'Basic') }

                break
            }
            'String' {
                $Base64Auth = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$Credentials"))
                $IRMParameters = @{'Headers' = @{ 'Authorization' = "Basic $Base64Auth" }}

                break
            }
            Default { throw [System.NotSupportedException] "AffinitySettingObjectType not developed" }
        }
    }
    Process {
        $IRMParameters.Add('Method', $Method)
        $IRMParameters.Add('Uri', ( "{0}/{1}" -f $BaseUrl, $Fragment ))

        # Handle content
        if ($Content) {
            if (Test-NestedCollection -Collection $Content) {
                $IRMParameters.Add('Body', ( $Content | ConvertTo-Json -Compress -Depth 10 ))
                $IRMParameters.Add('ContentType', 'application/json')
            }
            else {
                $IRMParameters.Add('Body', $Content)
            }
        }

        # Splat parameters
        Invoke-RestMethod @IRMParameters
    }
}
