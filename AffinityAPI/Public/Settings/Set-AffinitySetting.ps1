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
        switch ($AffinitySettingObjectType) {
            'Credential' {
                $SAOCParameters = @{
                    'Name'      = 'AffinityCredentials'
                    'CacheType' = $AffinitySettingCacheType
                    'Value'     = $Credentials
                }

                break
            }
            'String' {
                $SAOCParameters = @{
                    'Name'      = 'AffinityApiKey'
                    'CacheType' = $AffinitySettingCacheType
                    'Value'     = $Credentials.GetNetworkCredential().password
                }

                break
            }
            Default { throw [System.NotSupportedException] "AffinitySettingObjectType not developed" }
        }

        if ((Set-AffinityObjectCache @SAOCParameters) -and
            (Set-AffinityObjectCache -Name AffinityBaseUrl -Value $BaseUrl)) { return $true }
        else { return $false }
    }
}
