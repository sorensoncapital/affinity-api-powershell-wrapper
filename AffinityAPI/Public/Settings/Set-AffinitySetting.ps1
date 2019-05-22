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

function Set-AffinitySetting {
    [CmdletBinding(PositionalBinding = $true)]
    [OutputType([bool])]
    param (
        # Credentials
        [Parameter(Mandatory = $false,
                   Position = 0)]
        [ValidateNotNullOrEmpty()]
        [pscredential]
        $Credentials = (
            Get-Credential -Title   'Affinity API Key' `
                           -Message 'Please enter Affinity user name and API key'
        ),

        # BaseUrl
        [Parameter(Mandatory = $false,
                   Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string]
        $BaseUrl = $AffinityStandardBaseUrl
    )

    process {
        switch ($AffinityCacheType.Setting) {
            'ScriptVariable' {
                $script:AffinityCredentials = $Credentials
                $script:AffinityBaseUrl = $BaseUrl
            }
            'EnvironmentVariable' {
                $env:AFFINITY_CREDENTIALS = ( $Credentials | ConvertTo-CliXml )
                $env:AFFINITY_BASE_URL = $BaseUrl
            }
        }

        return $true
    }
}