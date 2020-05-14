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
        [ValidateScript({
            if ($_ -eq 'EnvironmentVariable' -and $PSVersionTable.PSVersion -lt 5.1 ) { $false }
            else { $true }
        })]
        [string]
        $CacheType = $AffinityObjectCacheType
    )

    Process {
        switch ($CacheType) {
            'ScriptVariable' {
                return Get-Variable -Name $Name -Scope script -ValueOnly -ErrorAction SilentlyContinue
            }
            'EnvironmentVariable' {
                $EnvName = ConvertTo-EnvironmentVariableCase -Name $Name
                $EnvOutput = Get-Content -Path "env:$EnvName" -ErrorAction SilentlyContinue

                if ($EnvOutput) {
                    if ([bool]($EnvOutput -as [xml])) {
                        return [System.Management.Automation.PSSerializer]::Deserialize($EnvOutput)
                    }
                    else { return $EnvOutput }
                }
            }
            # Default { throw [System.NotSupportedException] "CacheType not developed" }
        }
    }
}