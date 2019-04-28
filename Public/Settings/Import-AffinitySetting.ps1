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
        # AutoName: Settings Directory
        [Parameter(Mandatory = $false,
                   ParameterSetName = 'AutoName',
                   Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]
        $SettingDir = (Get-AffinitySettingDir),

        # AutoName: Username
        [Parameter(Mandatory = $true,
                   ParameterSetName = 'AutoName',
                   Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string]
        $SettingUserName,

        # ManualName: Path
        [Parameter(Mandatory = $true,
                   ParameterSetName = 'ManualName',
                   Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]
        $SettingPath
    )

    process {
        switch ($PSCmdlet.ParameterSetName) {
            'AutoName' {
                $ImportPath = Join-Path -Path $SettingDir `
                                        -ChildPath (Get-AffinitySettingName -SettingUserName $SettingUserName)
            }
            'ManualName' {
                $ImportPath = $SettingPath
            }
            Default { <# Throw error #> }
        }

        if (Test-Path $ImportPath) {
            $ImportedSetting = Import-Clixml -LiteralPath $ImportPath

            if ($ImportedSetting.Module -ilike $MyInvocation.MyCommand.ModuleName) {
                Set-AffinitySetting -Credentials $ImportedSetting.Credentials -BaseUrl $ImportedSetting.Url
            }
            else {
                throw [System.NotSupportedException] ("Setting for different module {0}" -f $ImportedSetting.Module)
            }
        }
        else { throw [System.IO.FileNotFoundException] "Setting failed to be imported" }
    }
}
