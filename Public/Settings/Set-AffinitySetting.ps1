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

function Set-AffinitySetting {
    [CmdletBinding(PositionalBinding = $true)]
    [OutputType([bool])]
    param (
        # Credentials
        [Parameter(Mandatory = $false,
                   Position = 0)]
        [pscredential]
        $Credentials = (Get-Credential),

        # Url
        [Parameter(Mandatory = $false,
                   Position = 1)]
        [Alias('AffinityUrl')]
        [Alias('AffinityBaseUrl')]
        [string]
        $Url = $AffinityStandardBaseUrl
    )

    Set-Variable -Name AffinityCredentials -Scope Script -Value $Credentials -Option ReadOnly -Force
    Set-Variable -Name AffinityBaseUrl -Scope Script -Value $Url -Option ReadOnly -Force
    
    return $true
}