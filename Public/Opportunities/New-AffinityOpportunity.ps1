<#
.Synopsis
   Create a new Affinity opportunity
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
   General notes
#>
function New-AffinityOpportunity
{
    [CmdletBinding(PositionalBinding = $true,
                   HelpUri = 'https://api-docs.affinity.co/#create-a-new-opportunity')]
    [OutputType([String])]
    Param
    (
        # Affinity opportunity name
        [Parameter(Mandatory = $true,
                   Position = 0)]
        [string]
        $OpportunityName,

        # Affinity list_id
        [Parameter(Mandatory = $true,
                   Position = 1)]
        [int]
        $ListID,

        # Affinity person_ids
        [Parameter(Mandatory = $false,
                   Position = 2)]
        [int[]]
        $PersonIDs,

        # Affinity organization_ids
        [Parameter(Mandatory = $false,
                   Position = 3)]
        [int[]]
        $OrganizationIDs
    )

    Process {
        # Add mandatory parameters
        $Content = @{
            'name' = $OpportunityName
            'list_id' = $ListID
        }

        # Add optional parameters
        if ($PersonIDs)         { $Content.Add( 'person_ids',        $PersonIDs       ) }
        if ($OrganizationIDs)   { $Content.Add( 'organization_ids',  $OrganizationIDs ) }

        Invoke-AffinityAPIRequest -Method Post -Fragment "opportunities" -Content $Content
    }
}
