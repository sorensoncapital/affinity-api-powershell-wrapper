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
   Notes
#>

function Get-AffinitySetting {
    [CmdletBinding(PositionalBinding = $true)]
    param (
        # Credentials
        [Parameter(Mandatory = $true,
                   ParameterSetName = 'Credentials',
                   Position = 0)]
        [switch]
        $Credentials,

        # URL
        [Parameter(Mandatory = $true,
                   ParameterSetName = 'BaseUrl',
                   Position = 0)]
        [switch]
        $BaseUrl
    )

    switch ($PSCmdlet.ParameterSetName) {
        'Credentials' {
            switch ($AffinityCacheType) {
                'ScriptVariable' {
                    return $AffinityCredentials
                    break
                }
                'EnvironmentVariable' {
                    return ( $env:AFFINITY_CREDENTIALS | ConvertFrom-CliXml )
                    break
                }
            }
        }

        'BaseUrl' {
            switch ($AffinityCacheType) {
                'ScriptVariable' {
                    return $AffinityBaseUrl
                    break
                }
                'EnvironmentVariable' {
                    return ( $env:AFFINITY_BASE_URL | ConvertFrom-CliXml )
                    break
                }
            }
        }
    }
}
