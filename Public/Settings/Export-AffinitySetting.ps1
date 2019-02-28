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

function Export-AffinitySetting {
    [CmdletBinding(PositionalBinding = $true,
                   DefaultParameterSetName = 'AutoName')]
    [OutputType([string])]
    param (
        # AutoName: Settings Director
        [Parameter(Mandatory = $false,
                   ParameterSetName = 'AutoName',
                   Position = 0)]
        [string]
        $SettingsDir = (Get-AffinitySettingsDir),

        # AutoName: Setting Name
        [Parameter(Mandatory = $false,
                   ParameterSetName = 'AutoName',
                   Position = 1)]
        [string]
        $SettingName = (Get-AffinitySettingName -UserName $AffinityCredentials.UserName),

        # ManualName: Path
        [Parameter(Mandatory = $true,
                   ParameterSetName = 'ManualName',
                   Position = 0)]
        [string]
        $SettingPath
    )

    process {
        switch ($PSCmdlet.ParameterSetName) {
            'AutoName' { $ExportPath = Join-Path -Path $SettingsDir -ChildPath $SettingName }
            'ManualName' { $ExportPath = $SettingPath }
            Default {}
        }

        New-Item -Path $ExportPath -Force | Out-Null

        @{
            'Credentials' = $AffinityCredentials
            'Url' = $AffinityBaseUrl
        } | Export-Clixml -Path $ExportPath -Force | Out-Null

        if (Test-Path $ExportPath) { return $ExportPath }
        else {
            # Throw error 
        }
    }
}