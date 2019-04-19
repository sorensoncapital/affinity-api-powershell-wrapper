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
    [OutputType([System.Management.Automation.PSObject[]])]
    Param ( )

    Process {
        switch ($AffinityCacheType) {
            'ScriptVariable' {
                if ($Affinity_Last_OrganizationGlobalFieldHeaders) {
                    $Output = $Affinity_Last_OrganizationGlobalFieldHeaders
                    break
                }
            }
            'EnvironmentVariable' {
                if ($env:AFFINITY_LAST_ORGANIZATIONGLOBALFIELDHEADERS) {
                    $Output = $env:AFFINITY_LAST_ORGANIZATIONGLOBALFIELDHEADERS | ConvertFrom-CliXml
                    break
                }
            }
        }

        if ($Output) { return $Output }
        else {
            $Output = Invoke-AffinityAPIRequest -Method Get -Fragment "organizations/fields"

            switch ($AffinityCacheType.OrganizationGlobalFieldHeaders) {
                'ScriptVariable' {
                    $script:Affinity_Last_OrganizationGlobalFieldHeaders = $Output
                    break
                }
                'EnvironmentVariable' {
                    [System.Environment]::SetEnvironmentVariable('AFFINITY_LAST_ORGANIZATIONGLOBALFIELDHEADERS', ($Output | ConvertTo-CliXml))
                    break
                }
            }

            return $Output
        }
    }
}
