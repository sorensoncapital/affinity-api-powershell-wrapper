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
function Get-AffinityList
{
    [CmdletBinding(PositionalBinding = $true,
                   DefaultParameterSetName = 'ListName',
                   HelpUri = 'https://api-docs.affinity.co/#get-a-specific-list')]
    [OutputType([Array])]
    Param
    (
        # Affinity List Name
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ParameterSetName = 'ListName')]
        [String]
        $ListName,

        # Affinity List ID
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ParameterSetName = 'ListID')]
        [Int]
        $ListID
    )

    Process {
        if ($ListName) {
            # Refresh simple cache
            if (!$Script:Affinity_Last_Lists) { Get-AffinityLists | Out-Null }

            $ListID = $Affinity_Last_Lists | Where-Object { $_.name -like $ListName } | Select-Object -First 1 -ExpandProperty 'id'
        }

        # Do a separate API call (instead of filtering the List collection) in order to get the .fields[] subarray
        # This way all output is congruent
        $Script:Affinity_Last_List = Invoke-AffinityAPIRequest -Method Get -Fragment ("lists/{0}" -f $ListID)

        return $Affinity_Last_Lists
    }
}
