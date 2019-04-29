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
        switch ($AffinityCacheType.OrganizationGlobalFieldHeaders) {
            'ScriptVariable' {
                if ($AffinityLastOrganizationGlobalFieldHeaders) {
                    $Output = $AffinityLastOrganizationGlobalFieldHeaders
                    break
                }
            }
            'EnvironmentVariable' {
                if ($env:AFFINITY_LAST_ORGANIZATION_GLOBAL_FIELD_HEADERS) {
                    $EnvInput = $env:AFFINITY_LAST_ORGANIZATION_GLOBAL_FIELD_HEADERS | ConvertFrom-CliXml

                    if (($EnvInput | Measure-Object).Count -gt 0) { $Output = $EnvInput }

                    break
                }
            }
        }

        if (!$Output) {
            $Output = Invoke-AffinityAPIRequest -Method Get -Fragment "organizations/fields"

            switch ($AffinityCacheType.OrganizationGlobalFieldHeaders) {
                'ScriptVariable' {
                    $script:AffinityLastOrganizationGlobalFieldHeaders = $Output
                    break
                }
                'EnvironmentVariable' {
                    $EnvOutput = $Output | ConvertTo-CliXml

                    if ($EnvOutput.length -le 32767) {
                        $env:AFFINITY_LAST_ORGANIZATION_GLOBAL_FIELD_HEADERS = $EnvOutput
                    }

                    break
                }
            }
        }

        return $Output
    }
}
