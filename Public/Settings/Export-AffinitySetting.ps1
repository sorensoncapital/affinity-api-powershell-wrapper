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
        # AutoName: Settings Directory
        [Parameter(Mandatory = $false,
                   ParameterSetName = 'AutoName',
                   Position = 0)]
        [string]
        $SettingsDir = (Get-AffinitySettingDir),

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
        $SettingPath,

        # Credential
        [Parameter(Mandatory = $false,
                   Position = 1)]
        [ValidateScript({
            if ($_.Password) { $true }
            else { $false }
        })] 
        [pscredential]
        $Credentials = $AffinityCredentials
    )

    process {
        switch ($PSCmdlet.ParameterSetName) {
            'AutoName' { $ExportPath = Join-Path -Path $SettingsDir -ChildPath $SettingName }
            'ManualName' { $ExportPath = $SettingPath }
            Default { <# Throw error #> }
        }

        New-Item -Path $ExportPath -Force | Out-Null

        @{
            'Module'        = $MyInvocation.MyCommand.ModuleName
            'Credentials'   = $Credentials
            'Url'           = $AffinityBaseUrl
        } | Export-Clixml -Path $ExportPath -Force | Out-Null

        if (Test-Path $ExportPath) { return $ExportPath }
        else { throw [System.IO.FileNotFoundException] "Setting failed to be exported" }
    }
}