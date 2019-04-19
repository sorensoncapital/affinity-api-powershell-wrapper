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
function Get-AffinityNote
{
    [CmdletBinding(PositionalBinding = $true,
                   HelpUri = 'https://api-docs.affinity.co/#get-a-specific-note')]
    [OutputType([hashtable])]
    Param
    (
        # Affinity note_id
        [Parameter(Mandatory = $true,
                   Position = 0)]
        [long]
        $NoteID
    )

    Process { Invoke-AffinityAPIRequest -Method Get -Fragment ("notes/{0}" -f $NoteID) }
}
