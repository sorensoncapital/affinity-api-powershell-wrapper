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
function Set-AffinityFieldValue
{
    [CmdletBinding(PositionalBinding = $true,
                   HelpUri = 'https://api-docs.affinity.co/#update-a-field-value')]
    [OutputType([String])]
    Param
    (
        # Affinity field_value_id
        [Parameter(Mandatory = $true, 
                   Position = 0)]
        [int]
        $FieldValueID,

        # Affinity field_value
        [Parameter(Mandatory = $true,
                   Position = 1)]
        $FieldValue
    )

    Process { Invoke-AffinityAPIRequest -Method Put -Fragment ("field-values/{0}" -f $FieldValueID) -Content @{ 'value' = $FieldValue } }
}