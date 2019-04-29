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

function Test-NestedContainer {
    [CmdletBinding(PositionalBinding = $true)]
    [OutputType([bool])]
    Param (
        # Collection
        [Parameter(Mandatory = $true,
                   Position = 0)]
        [ValidateNotNullOrEmpty()]
        [hashtable]
        $Collection
    )

    process {
        foreach ($value in $Collection.Values) {
            if ($item -is [System.Collections.ICollection]) { return $true }
        }

        $false
    }
}
