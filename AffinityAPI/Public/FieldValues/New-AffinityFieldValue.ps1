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
.LINK
    https://api-docs.affinity.co/#create-a-new-field-value
#>
function New-AffinityFieldValue
{
    [CmdletBinding(PositionalBinding = $true)]
    [OutputType([System.Management.Automation.PSObject])]
    Param
    (
        # Affinity field_id
        [Parameter(Mandatory = $true,
                   Position = 0)]
        [ValidateNotNullOrEmpty()]
        [long]
        $FieldID,

        # Affinity entity_id
        [Parameter(Mandatory = $true,
                   Position = 1)]
        [ValidateNotNullOrEmpty()]
        [long]
        $EntityID,

        # Affinity list_entry_id
        [Parameter(Mandatory = $false,
                   Position = 2)]
        [long]
        $ListEntryID,

        # Affinity field_value
        [Parameter(Mandatory = $true,
                   Position = 3)]
        [ValidateNotNullOrEmpty()]
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
