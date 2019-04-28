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
.LINK
    https://api-docs.affinity.co/#get-all-notes
.LINK
    https://api-docs.affinity.co/#get-a-specific-note
#>
function Get-AffinityNote
{
    [CmdletBinding(PositionalBinding = $true,
                   DefaultParameterSetName = 'AllNotes')]
    [OutputType([System.Management.Automation.PSObject[]],
                ParameterSetName=('AllNotes',
                                  'PersonIDNotes',
                                  'OrganizationIDNotes',
                                  'OpportunityIDNotes',
                                  'CreatorIDNotes'))]
    [OutputType([System.Management.Automation.PSObject],
                ParameterSetName='NoteIDNote')]
    Param
    (
        # Affinity note_id
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ParameterSetName = 'NoteIDNote')]
        [ValidateNotNullOrEmpty()]
        [long]
        $NoteID,

        # Affinity person_id
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ParameterSetName = 'PersonIDNotes')]
        [ValidateNotNullOrEmpty()]
        [long]
        $PersonID,

        # Affinity organization_id
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ParameterSetName = 'OrganizationIDNotes')]
        [ValidateNotNullOrEmpty()]
        [long]
        $OrganizationID,

        # Affinity opportunity_id
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ParameterSetName = 'OpportunityIDNotes')]
        [ValidateNotNullOrEmpty()]
        [long]
        $OpportunityID,

        # Affinity creator_id
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ParameterSetName = 'CreatorIDNotes')]
        [ValidateNotNullOrEmpty()]
        [long]
        $CreatorID
    )

    Process {
        $Fragment = "notes"

        switch ($PSCmdlet.ParameterSetName) {
            'AllNotes' { break }
            'NoteIDNote' {
                $Fragment = "notes/{0}" -f $NoteID
                break
            }
            'PersonIDNotes' {
                $Content = @{ 'person_id' = $PersonID }
                break
            }
            'OrganizationIDNotes' {
                $Content = @{ 'organization_id' = $OrganizationID }
                break
            }
            'OpportunityIDNotes' {
                $Content = @{ 'opportunity_id' = $OpportunityID }
                break
            }
            'CreatorIDNotes' {
                $Content = @{ 'creator_id' = $CreatorID}
                break
            }
        }

        Invoke-AffinityAPIRequest -Method Get -Fragment $Fragment -Content $Content
    }
}
