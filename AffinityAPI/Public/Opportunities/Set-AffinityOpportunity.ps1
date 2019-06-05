<#
.Synopsis
    Updates an existing opportunity with opportunity_id with the supplied parameters
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
    If you are trying to add a person to an opportunity, the existing values for person_ids must also be passed
    into the endpoint.

    If you are trying to add an organization to an opportunity, the existing values for organization_ids must also
    be passed into the endpoint.
.LINK
    https://api-docs.affinity.co/#update-an-opportunity
#>
function Set-AffinityOpportunity
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
        $OpportunityID,

        # Affinity opportunity_name
        [Parameter(Mandatory = $false,
                   Position = 1)]
        [string]
        $OpportunityName,

        # Affinity person_ids
        [Parameter(Mandatory = $false,
                   Position = 2)]
        [long[]]
        $PersonIDs,

        # Affinity organization_ids
        [Parameter(Mandatory = $false,
                   Position = 3)]
        [long[]]
        $OrganizationIDs
    )

    Process {
        if ($OpportunityName -or $PersonIDs -or $OrganizationIDs) {

            $Content = @{ }
            if ($OpportunityName)   { $Content.Add( 'name',             $OpportunityName  ) }
            if ($PersonIDs)         { $Content.Add( 'person_ids',       $PersonIDs        ) }
            if ($OrganizationIDs)   { $Content.Add( 'organization_ids', $OrganizationIDs  ) }

            Invoke-AffinityAPIRequest -Method Put -Fragment ("opportunities/{0}" -f $OpportunityID) -Content $Content
        }
        else { throw [System.ArgumentNullException] "No fields to update" }
    }
}
