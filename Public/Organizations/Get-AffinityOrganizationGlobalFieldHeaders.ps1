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
        switch ($AffinityCacheType.OrganizationGlobalFieldHeaders) {
            'ScriptVariable' {
                if ($Affinity_Last_OrganizationGlobalFieldHeaders) {
                    $Output = $Affinity_Last_OrganizationGlobalFieldHeaders
                    break
                }
            }
            'EnvironmentVariable' {
                if ($env:AFFINITY_LAST_ORGANIZATIONGLOBALFIELDHEADERS) {
                    $EnvInput = $env:AFFINITY_LAST_ORGANIZATIONGLOBALFIELDHEADERS | ConvertFrom-CliXml

                    if (($EnvInput | Measure-Object).Count -gt 0) { $Output = $EnvInput }

                    break
                }
            }
        }

        if (!$Output) {
            $Output = Invoke-AffinityAPIRequest -Method Get -Fragment "organizations/fields"

            switch ($AffinityCacheType.OrganizationGlobalFieldHeaders) {
                'ScriptVariable' {
                    $script:Affinity_Last_OrganizationGlobalFieldHeaders = $Output
                    break
                }
                'EnvironmentVariable' {
                    $EnvOutput = $Output | ConvertTo-CliXml

                    if ($EnvOutput.length -le 32767) {
                        $env:AFFINITY_LAST_ORGANIZATIONGLOBALFIELDHEADERS = $EnvOutput
                    }

                    break
                }
            }
        }

        return $Output
    }
}
