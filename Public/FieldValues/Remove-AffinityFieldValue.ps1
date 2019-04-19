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
function Remove-AffinityFieldValue
{
    [CmdletBinding(PositionalBinding = $true,
                   HelpUri = 'https://api-docs.affinity.co/#delete-a-field-value')]
    [OutputType([hashtable])]
    Param
    (
        # Affinity field_value_id
        [Parameter(Mandatory = $true,
                   Position = 0)]
        [long]
        $FieldValueID
    )

    Process { Invoke-AffinityAPIRequest -Method Delete -Fragment ("field-values/{0}" -f $FieldValueID) }
}
