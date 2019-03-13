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

function Find-NestedContainer {
    [CmdletBinding()]
    Param (
        # Collection
        [Parameter(Mandatory = $true,
                   Position = 0)]
        [hashtable]
        $Collection
    )

    process {
        $Result = $false

        foreach ($pair in $Collection.GetEnumerator()) {
            if ($pair.value -is [hashtable] -or `
                $pair.value -is [array] -or `
                $pair.value -is [System.Object[]] -or `
                $pair.value -is [System.Collections.ArrayList]) {
                $Result = $true
            }
        }

        return $Result
    }
}
