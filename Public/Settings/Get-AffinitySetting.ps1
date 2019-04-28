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
                switch ($AffinityCacheType.Setting) {
                    'ScriptVariable' {
                        if ($AffinityCredentials) { $Output = $AffinityCredentials }
                        break
                    }
                    'EnvironmentVariable' {
                        if ($env:AFFINITY_CREDENTIALS) { $Output = $env:AFFINITY_CREDENTIALS | ConvertFrom-CliXml }
                        break
                    }
                }
            }

            'BaseUrl' {
                switch ($AffinityCacheType.Setting) {
                    'ScriptVariable' {
                        if ($AffinityBaseUrl) { $Output = $AffinityBaseUrl }
                        break
                    }
                    'EnvironmentVariable' {
                        if ($env:AFFINITY_BASE_URL) { $Output = $env:AFFINITY_BASE_URL | ConvertFrom-CliXml }
                        break
                    }
                }
            }
        }

        if ($Output) { return $Output }
        else { return $false }
    }
}
