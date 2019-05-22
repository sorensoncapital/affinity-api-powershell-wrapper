<#
.Synopsis
    Update a field-value
.DESCRIPTION
    This function updates a field-value based on a field_value_id.

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
.PARAMETER FieldValueID
    The field_value_id from Affinity
.PARAMETER FieldValue
    The value to update for a given field
.EXAMPLE
    $ListEntries = Get-AffinityListEntry -ListName 'List'

    foreach ($entry in $ListEntries) {
        $EntryFieldValues = Get-AffinityFieldValue -OrganizationID $entry.entity.id -ListID $entry.list_id -Expand
        if ($EntryFieldValues.'Status'.field_value -like "Error") {
            Update-AffinityFieldValue -FieldValueID $EntryFieldValues.'Status'.field_value_id `
                                      -FieldValue "Success"
        }
    }
.OUTPUTS
    System.Management.Automation.PSObject
.NOTES
    No enhancements planned.
.LINK
    https://api-docs.affinity.co/#fields
.LINK
    https://api-docs.affinity.co/#field-values
.LINK
    https://api-docs.affinity.co/#the-field-value-resource
.LINK
    https://api-docs.affinity.co/#update-a-field-value
#>
function Set-AffinityFieldValue
{
    [CmdletBinding(PositionalBinding = $true)]
    [OutputType([System.Management.Automation.PSObject])]
    Param
    (
        # Affinity field_value_id
        [Parameter(Mandatory = $true,
                   Position = 0)]
        [ValidateNotNullOrEmpty()]
        [long]
        $FieldValueID,

        # Affinity field_value
        [Parameter(Mandatory = $true,
                   Position = 1)]
        [ValidateNotNullOrEmpty()]
        $FieldValue
    )

    Process {
        $IAARParameters = @{
            Method = 'Put'
            Fragment = "field-values/{0}" -f $FieldValueID
            Content = @{ 'value' = $FieldValue }
        }

        Invoke-AffinityAPIRequest @IAARParameters
    }
}
