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
function Get-AffinityOrganizationGlobalFieldHeaders
{
    [CmdletBinding(PositionalBinding = $true,
                   HelpUri = 'https://api-docs.affinity.co/#get-global-fields36')]
    [OutputType([array])]
    Param ( )

    Process {
        $Script:Affinity_Last_OrganizationGlobalFieldHeaders = Invoke-AffinityAPIRequest -Method Get -Fragment "organizations/fields"
        return $Affinity_Last_OrganizationGlobalFieldHeaders
    }
}
