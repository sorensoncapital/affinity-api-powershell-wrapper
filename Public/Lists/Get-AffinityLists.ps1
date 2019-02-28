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
function Get-AffinityLists
{
    [CmdletBinding(PositionalBinding = $true,
                   HelpUri = 'https://api-docs.affinity.co/#get-all-lists')]
    [OutputType([Array])]
    Param ( )

    Process { 
      $Script:Affinity_Last_Lists = Invoke-AffinityAPIRequest -Method Get -Fragment "lists"
      return $Affinity_Last_Lists
   }
}