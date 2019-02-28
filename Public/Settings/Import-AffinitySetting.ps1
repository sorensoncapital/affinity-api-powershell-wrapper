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
    [OutputType([string])]
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
            'AutoName' { $ImportPath = Join-Path -Path (Get-AffinitySettingsDir) -ChildPath (Get-AffinitySettingName -UserName $UserName) }
            'ManualName' { $ImportPath = $SettingPath }
            Default {}
        }

        if (Test-Path $ImportPath) { 
            $ImportedSetting = Import-Clixml -LiteralPath $ImportPath
            Set-AffinitySetting -Credentials $ImportedSetting.Credentials -Url $ImportedSetting.Url
        }
        else {
            # Throw error 
        }
    }
}