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
function Get-AffinityListEntries
{
    [CmdletBinding(PositionalBinding = $true,
                   DefaultParameterSetName = 'ListName',
                   HelpUri = 'https://api-docs.affinity.co/#get-all-list-entries')]
    [OutputType([System.Management.Automation.PSObject[]])]
    Param
    (
        # Affinity List Name
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ParameterSetName = 'ListName')]
        [string]
        $ListName,

        # Affinity list_id
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ParameterSetName = 'ListID')]
        [long]
        $ListID
    )

    Process {
        if ($ListName) {
            $ListID = (Get-AffinityList -ListName $ListName).id
        }

        Invoke-AffinityAPIRequest -Method Get -Fragment ("lists/{0}/list-entries" -f $ListID)
    }
}
