<#
.Synopsis
   Creates a new note
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
function New-AffinityNote
{
    [CmdletBinding(PositionalBinding = $true,
                   DefaultParameterSetName = 'Content',
                   HelpUri = 'https://api-docs.affinity.co/#create-a-new-note')]
    [OutputType([String])]
    Param
    (
        # Affinity Note Content
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ParameterSetName = 'Content')]
        [string]
        $NoteContent,

        # Affinity gmail_id
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ParameterSetName = 'GmailID')]
        [string]
        $GmailID,

        # Affinity person_ids
        [Parameter(Mandatory = $false,
                   Position = 1)]
        [int[]]
        $PersonIDs,

        # Affinity organization_ids
        [Parameter(Mandatory = $false,
                   Position = 2)]
        [int[]]
        $OrganizationIDs,

        # Affinity opportunity_ids
        [Parameter(Mandatory = $false,
                   Position = 3)]
        [int[]]
        $OpportunityIDs,

        # Affinity creator_id
        [Parameter(Mandatory = $false,
                   Position = 4)]
        [int]
        $CreatorID,

        # Affinity created_at
        [Parameter(Mandatory = $false,
                   Position = 5)]
        [datetime]
        $CreatedAt
    )

    Process {
        # Add mandatory parameters
        switch ($PSCmdlet.ParameterSetName) {
           'Content'            { $Content = @{ 'content' =         $NoteContent             } }
           'GmailID'            { $Content = @{ 'gmail_id' =        $GmailID                 } }
           Default              { <# Throw Error #>                                            }
        }

        # Add optional parameters
        if ($PersonIDs)         { $Content.Add( 'person_ids',       $PersonIDs               ) }
        if ($OrganizationIDs)   { $Content.Add( 'organization_ids', $OrganizationIDs         ) }
        if ($OpportunityIDs)    { $Content.Add( 'opportunity_ids',  $OpportunityIDs          ) }
        if ($CreatorID)         { $Content.Add( 'creator_id',       $CreatorID               ) }
        if ($CreatedAt)         { $Content.Add( 'created_at',       $CreatedAt.ToString('o') ) }

        Invoke-AffinityAPIRequest -Method Post -Fragment "notes" -Content $Content
    }
}
