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
function Get-AffinityList
{
    [CmdletBinding(PositionalBinding = $true,
                   DefaultParameterSetName = 'ListName',
                   HelpUri = 'https://api-docs.affinity.co/#get-a-specific-list')]
    [OutputType([System.Management.Automation.PSObject])]
    Param
    (
        # Affinity List Name
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ParameterSetName = 'ListName')]
        [string]
        $ListName,

        # Affinity List ID
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ParameterSetName = 'ListID')]
        [long]
        $ListID
    )

    Process {
        # Get List ID if List Name is provided
        if ($ListName) {
            $ListID = Get-AffinityLists |
                        Where-Object { $_.name -like $ListName } |
                        Select-Object -First 1 -ExpandProperty 'id'
        }

        # Check simple cache for the last list
        switch ($AffinityCacheType.List) {
            'ScriptVariable' {
                if ($Affinity_Last_List) {
                    $Output = $Affinity_Last_List
                    break
                }
            }
            'EnvironmentVariable' {
                if ($env:AFFINITY_LAST_LIST) {
                    $EnvInput = $env:AFFINITY_LAST_LIST | ConvertFrom-CliXml

                    if (($EnvInput | Measure-Object).Count -gt 0) { $Output = $EnvInput }

                    break
                }
            }
        }

        # Call API if last list is not available in the cache
        if (!$Output -or $Output.id -ne $ListID) {
            # Do a separate API call (instead of filtering the List collection) in order to get the .fields[]
            # subarray so all output is congruent

            $Output = Invoke-AffinityAPIRequest -Method Get -Fragment ("lists/{0}" -f $ListID)

            # Set cache
            switch ($AffinityCacheType.List) {
                'ScriptVariable' {
                    $script:Affinity_Last_List = $Output
                    break
                }
                'EnvironmentVariable' {
                    $EnvOutput = $Output | ConvertTo-CliXml

                    if ($EnvOutput.length -le 32767) {
                        $env:AFFINITY_LAST_LIST = $EnvOutput
                    }

                    break
                }
            }
        }

        return $Output
    }
}
