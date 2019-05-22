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
