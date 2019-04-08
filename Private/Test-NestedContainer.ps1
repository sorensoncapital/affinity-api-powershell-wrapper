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
        [hashtable]
        $Collection
    )

    process {
        $Collection.Values.ForEach{
            if( $_ -is [System.Collections.ICollection] ) { $Test = $true }
        }

        return $Test
    }
}
