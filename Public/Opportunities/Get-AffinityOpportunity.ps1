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
function Get-AffinityOpportunity
{
    [CmdletBinding(PositionalBinding = $true,
                   HelpUri = 'https://api-docs.affinity.co/#get-a-specific-opportunity')]
    [OutputType([Array])]
    Param
    (
        # Affinity Opportunity ID
        [Parameter(Mandatory = $true,
                   Position = 0)]
        [int]
        $OpportunityID
    )

    Process { Invoke-AffinityAPIRequest -Method Get -Fragment ("opportunities/{0}" -f $OpportunityID) }
}