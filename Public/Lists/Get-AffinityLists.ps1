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
        # Check simple cache for lists
        switch ($AffinityCacheType.Lists) {
            'ScriptVariable' {
                if ($Affinity_Last_Lists) {
                    $Output = $Affinity_Last_Lists
                    break
                }
            }
            'EnvironmentVariable' {
                if ($env:AFFINITY_LAST_LISTS) {
                    $EnvInput = $env:AFFINITY_LAST_LISTS | ConvertFrom-CliXml

                    if (($EnvInput | Measure-Object).Count -gt 0) { $Output = $EnvInput }

                    break
                }
            }
        }

        # Call API if lists are not available in simple cache
        if (!$Output) {
            $Output = Invoke-AffinityAPIRequest -Method Get -Fragment "lists"

            # Set cache
            switch ($AffinityCacheType.Lists) {
                'ScriptVariable' {
                    $script:Affinity_Last_Lists = $Output
                    break
                }
                'EnvironmentVariable' {
                    $EnvOutput = $Output | ConvertTo-CliXml

                    if ($EnvOutput.length -le 32767) {
                        $env:AFFINITY_LAST_LISTS = $EnvOutput
                    }

                    break
                }
            }
        }

        return $Output
    }
}
