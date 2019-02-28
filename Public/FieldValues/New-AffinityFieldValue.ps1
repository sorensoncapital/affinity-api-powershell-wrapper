<#
.Synopsis
   Short description
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
function New-AffinityFieldValue
{
    [CmdletBinding(PositionalBinding = $true,
                   HelpUri = 'https://api-docs.affinity.co/#create-a-new-field-value')]
    [OutputType([String])]
    Param
    (
        # Affinity field_id
        [Parameter(Mandatory = $true, 
                   Position = 0)]
        [int]
        $FieldID,

        # Affinity entity_id
        [Parameter(Mandatory = $true, 
                   Position = 1)]
        [int]
        $EntityID,

        # Affinity list_entry_id
        [Parameter(Mandatory = $false, 
                   Position = 2)]
        [int]
        $ListEntryID,

        # Affinity field_value
        [Parameter(Mandatory = $true,
                   Position = 3)]
        $FieldValue
    )

    Process {
        $Content = @{
            'field_id' = $FieldID
            'entity_id' = $EntityID
            'value' = $FieldValue
        }

        if ($ListEntryID) { $Content.Add('list_entry_id', $ListEntryID) }

        Invoke-AffinityAPIRequest -Method Post -Fragment "field-values" -Content $Content
    }
}