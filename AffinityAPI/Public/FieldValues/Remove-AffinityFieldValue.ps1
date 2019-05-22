<#
.Synopsis
    Delete a field-value
.DESCRIPTION
    This function deletes a field-value based on a field_value_id.

    There is one peculiarity to be aware of:
        1) allows_multiple Attribute. If a given field has the allows_multiple attribute set, then
           Remove-AffinityFieldValue needs to be called for each field_value_id to be deleted.
.PARAMETER FieldValueID
    The field_value_id from Affinity
.EXAMPLE
    $ListEntries = Get-AffinityListEntry -ListName 'List'

    foreach ($entry in $ListEntries) {
        $EntryFieldValues = Get-AffinityFieldValue -OrganizationID $entry.entity.id -ListID $entry.list_id -Expand
        if ($EntryFieldValues.'Status'.field_value -like "Error") {
            Remove-AffinityFieldValue -FieldValueID $EntryFieldValues.'Status'.field_value_id
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
    https://api-docs.affinity.co/#delete-a-field-value
#>
function Remove-AffinityFieldValue
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
        $FieldValueID
    )

    Process { Invoke-AffinityAPIRequest -Method Delete -Fragment ("field-values/{0}" -f $FieldValueID) }
}
