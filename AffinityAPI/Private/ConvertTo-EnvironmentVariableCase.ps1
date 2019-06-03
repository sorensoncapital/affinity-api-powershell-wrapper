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

function ConvertTo-EnvironmentVariableCase {
    [CmdletBinding(PositionalBinding = $true)]
    [OutputType([string])]
    param (
        # Variable name
        [Parameter(Mandatory = $true,
                   Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Name
    )

    ($Name -creplace '([A-Z])(?<![a-z])','_$&').trim(" _").toupper()
}