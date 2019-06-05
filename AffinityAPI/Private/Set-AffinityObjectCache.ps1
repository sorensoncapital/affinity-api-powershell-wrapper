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

function Set-AffinityObjectCache {
    [CmdletBinding(PositionalBinding = $true)]
    [OutputType([bool])]
    param (
        # Variable name
        [Parameter(Mandatory = $true,
                   Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name,

        # Cache type
        [Parameter(Mandatory = $false,
                   Position = 1)]
        [ValidateSet('ScriptVariable','EnvironmentVariable')]
        [string]
        $CacheType = $AffinityObjectCacheType,

        # Variable value
        [Parameter(Mandatory = $true,
                   Position = 2)]
        [ValidateNotNullOrEmpty()]
        $Value
    )

    process {
        switch ($CacheType) {
            'ScriptVariable' {
                Set-Variable -Name $Name -Scope script -Value $Value
                return $true
            }
            'EnvironmentVariable' {
                if ($Value -is [string] -or $Value -is [System.ValueType]) { $EnvOutput = $Value }
                else { $EnvOutput = $Value | ConvertTo-CliXml }

                if ($EnvOutput.length -le 32767) {
                    $EnvName = ConvertTo-EnvironmentVariableCase -Name $Name
                    $EnvOutput = Set-Content -Path "env:$EnvName" -Value $EnvOutput
                    return $true
                }
                else { return $false }
            }
            Default { throw [System.NotSupportedException] "CacheType not developed" }
        }
    }
}