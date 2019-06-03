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

    process {
        switch ($PSCmdlet.ParameterSetName) {
            'Credentials' {
                switch ($AffinitySettingObjectType) {
                    'Credential' {
                        $Output = Get-AffinityObjectCache -Name AffinityCredentials -CacheType $AffinitySettingCacheType
                        break
                    }
                    'String' {
                        $Output = Get-AffinityObjectCache -Name AffinityApiKey -CacheType $AffinitySettingCacheType
                        break
                    }
                }

                break
            }

            'BaseUrl' {
                $Output = Get-AffinityObjectCache -Name AffinityBaseUrl
                if (!$Output) { $Output = $AffinityStandardBaseUrl }
                break
            }
        }

        if ($Output) { return $Output }
        else { return $false }
    }
}
