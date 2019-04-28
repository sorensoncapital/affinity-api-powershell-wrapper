<#
.Synopsis
    Deletes an opportunity with a specified opportunity_id
.DESCRIPTION
    Long description
.EXAMPLE
    Example of how to use this cmdlet
.EXAMPLE
    Another example of how to use this cmdlet
.INPUTS
    Inputs to this cmdlet (if any)
.OUTPUTS
    Output from this cmdlet (if any)
.NOTES
    This will also delete all the field values, if any, associated with the opportunity.
.LINK
    https://api-docs.affinity.co/#delete-an-opportunity
#>
function Remove-AffinityOpportunity
{
    [CmdletBinding(PositionalBinding = $true)]
    [OutputType([System.Management.Automation.PSObject])]
    Param
    (
        # Affinity opportunity_id
        [Parameter(Mandatory = $true,
                   Position = 0)]
        [ValidateNotNullOrEmpty()]
        [long]
        $OpportunityID
    )

    Process { Invoke-AffinityAPIRequest -Method Delete -Fragment ("opportunities/{0}" -f $OpportunityID) }
}
