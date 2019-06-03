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
.LINK
    https://api-docs.affinity.co/#get-global-fields36
#>
function Get-AffinityOrganizationGlobalFieldHeader
{
    [CmdletBinding(PositionalBinding = $true)]
    [OutputType([System.Management.Automation.PSObject[]])]
    Param ( )

    Process {
        $Output = Get-AffinityObjectCache -Name AffinityLastOrganizationGlobalFieldHeaders

        if (!$Output) {
            $Output = Invoke-AffinityAPIRequest -Method Get -Fragment "organizations/fields"
            Set-AffinityObjectCache -Name AffinityLastOrganizationGlobalFieldHeaders -Value $Output
        }

        return $Output
    }
}
