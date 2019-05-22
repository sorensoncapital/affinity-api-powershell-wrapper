<#
.Synopsis
    Create a field-value for an entity
.DESCRIPTION
    This function creates a field-value based on a field_id, entity_id, and field_value (optionally a list_entry_id
    if updated a list-specific field).

    If a given field has never been set, New-AffinityFieldValue needs to be called instead of
    Set-AffinityFieldValue. Calling the wrong function will result in an error otherwise. The best way to test for
    this now is to call Get-AffinityFieldValue first, then decide which function to call based on whether a given
    field value is null or not.

    There are a few peculiarities to be aware of:
        1) allows_multiple Attribute. If a given field has the allows_multiple attribute set, then
           New-AffinityFieldValue needs to be called to add additional field values instead of
           Set-AffinityFieldValue.
        2) dropdown_options Attribute. If a given field has the dropdown_options attribute set, then the
           -FieldValue should be set with the desired dropdown value ID instead of the desired dropdown text.
        3) value_type Attribute. Each field has different value type, which requires a different input. Please
           see https://api-docs.affinity.co/#field-value-types for reference.
.PARAMETER FieldID
    The field_id from Affinity
.PARAMETER EntityID
    The entity_id from Affinity (could be a person_id, opportunity_id, or organization_id)
.PARAMETER ListEntryID
    The list_entry_id from Affinty
.PARAMETER FieldValue
    The value to create for a given field
.EXAMPLE
    $ListEntries = Get-AffinityListEntry -ListName 'List'

    foreach ($entry in $ListEntries) {
        $EntryFieldValues = Get-AffinityFieldValue -OrganizationID $entry.entity.id -ListID $entry.list_id -Expand
        if ($null = $EntryFieldValues.'Status'.field_value) {
            New-AffinityFieldValue -FieldID $EntryFieldValues.'Status'.id `
                                   -EntityID $entry.entity.id `
                                   -FieldValue "New"
        }
    }
.OUTPUTS
    System.Management.Automation.PSObject
.NOTES
    Need to perform two validations before invoking REST API call:
        1) Validate whether list_entry_id is required (server will throw error otherwise)
        2) Validate whether $FieldValue matched field type (server will throw error for egregious type differences,
           but not necessarily for minor differences). Validating this will usually require an additional 1-2 API
           calls if the necessary data is not already cached.
.LINK
    https://api-docs.affinity.co/#fields
.LINK
    https://api-docs.affinity.co/#field-values
.LINK
    https://api-docs.affinity.co/#the-field-value-resource
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
