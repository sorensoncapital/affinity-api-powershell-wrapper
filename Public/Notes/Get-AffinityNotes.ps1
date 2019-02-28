<#
.Synopsis
   Returns all notes attached to a person, organization, opportunity, or creator
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
function Get-AffinityNotes
{
    [CmdletBinding(PositionalBinding = $true,
                   DefaultParameterSetName = 'AllNotes',
                   HelpUri = 'https://api-docs.affinity.co/#get-all-notes')]
    [OutputType([Array])]
    Param
    (
        # Affinity person_id
        [Parameter(Mandatory = $false,
                   Position = 0,
                   ParameterSetName = 'AllNotes')]
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ParameterSetName = 'PersonIDNotes')]
        [int]
        $PersonID,

        # Affinity organization_id
        [Parameter(Mandatory = $false,
                   Position = 0,
                   ParameterSetName = 'AllNotes')]
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ParameterSetName = 'OrganizationIDNotes')]
        [int]
        $OrganizationID,

        # Affinity opportunity_id
        [Parameter(Mandatory = $false,
                   Position = 0,
                   ParameterSetName = 'AllNotes')]
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ParameterSetName = 'OpportunityIDNotes')]
        [int]
        $OpportunityID,

        # Affinity creator_id
        [Parameter(Mandatory = $false,
                   Position = 0,
                   ParameterSetName = 'AllNotes')]
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ParameterSetName = 'CreatorIDNotes')]
        [int]
        $CreatorID
    )

    Process { 
        if ($PersonID -or $OrganizationID -or $OpportunityID -or $CreatorID) {
            $Content = @{ }
            if     ($PersonID)          { $Content.Add( 'person_id',        $PersonID       ) }
            elseif ($OrganizationID)    { $Content.Add( 'organization_id',  $OrganizationID ) }
            elseif ($OpportunityID)     { $Content.Add( 'opportunity_id',   $OpportunityID  ) }
            elseif ($CreatorID)         { $Content.Add( 'creator_id',       $CreatorID      ) }
        }

        Invoke-AffinityAPIRequest -Method Get -Fragment ("notes") -Content $Content
    }
}