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
    [OutputType([System.Management.Automation.PSObject[]])]
    Param ( )

    Process {
        switch ($AffinityCacheType) {
            'ScriptVariable' {
                if ($Affinity_Last_Lists) {
                    $Output = $Affinity_Last_Lists
                    break
                }
            }
            'EnvironmentVariable' {
                if ($env:AFFINITY_LAST_LISTS) {
                    $Output = $env:AFFINITY_LAST_LISTS | ConvertFrom-CliXml
                    break
                }
            }
        }

        if ($Output) { return $Output }
        else {
            $Output = Invoke-AffinityAPIRequest -Method Get -Fragment "lists"

            switch ($AffinityCacheType) {
                'ScriptVariable' {
                    $script:Affinity_Last_Lists = $Output
                    break
                }
                'EnvironmentVariable' {
                    [System.Environment]::SetEnvironmentVariable('AFFINITY_LAST_LISTS', ($Output | ConvertTo-CliXml))
                    break
                }
            }

            return $Output
        }
    }
}
