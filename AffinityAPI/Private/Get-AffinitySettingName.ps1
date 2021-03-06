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

function Get-AffinitySettingName {
    [CmdletBinding()]
    param (
        # UserName
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $SettingUserName
    )

    process {
       ( $MyInvocation.MyCommand.ModuleName + "_" + `
       $env:COMPUTERNAME + "_" + `
       $env:USERNAME + "_" + `
       $SettingUserName + ".cred" )
   }
}
