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

function Import-AffinitySetting {
    [CmdletBinding(PositionalBinding = $true,
                   DefaultParameterSetName = 'AutoName')]
    [OutputType([bool])]
    param (
        # AutoName: Settings Director
        [Parameter(Mandatory = $true,
                   ParameterSetName = 'AutoName',
                   Position = 0)]
        [string]
        $UserName,

        # ManualName: Path
        [Parameter(Mandatory = $true,
                   ParameterSetName = 'ManualName',
                   Position = 0)]
        [string]
        $SettingPath
    )

    process {
        switch ($PSCmdlet.ParameterSetName) {
            'AutoName' { 
                $ImportPath = Join-Path -Path (Get-AffinitySettingDir) `
                                        -ChildPath (Get-AffinitySettingName -UserName $UserName)
            }
            'ManualName' { 
                $ImportPath = $SettingPath
            }
            Default { <# Throw error #>}
        }

        if (Test-Path $ImportPath) { 
            $ImportedSetting = Import-Clixml -LiteralPath $ImportPath
            
            if ($ImportedSetting.Module -ilike $MyInvocation.MyCommand.ModuleName) {
                Set-AffinitySetting -Credentials $ImportedSetting.Credentials -Url $ImportedSetting.Url
            }
            else { throw [System.NotSupportedException] ("Setting for different module {0}" -f $ImportedSetting.Module) }
        }
        else { throw [System.IO.FileNotFoundException] "Setting failed to be imported" }
    }
}