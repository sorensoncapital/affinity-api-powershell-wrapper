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

function Get-AffinityObjectCache {
    [CmdletBinding(PositionalBinding = $true)]
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
        $CacheType = $AffinityObjectCacheType
    )

    Process {
        switch ($CacheType) {
            'ScriptVariable' {
                $Output = Get-Variable -Name $Name -Scope script -ValueOnly -ErrorAction SilentlyContinue
                break
            }
            'EnvironmentVariable' {
                $EnvName = ConvertTo-EnvironmentVariableCase -Name $Name
                $EnvOutput = Get-Content -Path "env:$EnvName" -ErrorAction SilentlyContinue

                if ($EnvOutput) { $Output = $EnvOutput | ConvertFrom-CliXml }
                else { $Output = $null}

                break
            }
        }

        return $Output
    }
}