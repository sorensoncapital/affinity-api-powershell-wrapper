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
        if ($ListName) {
            $ListID = Get-AffinityLists |
                        Where-Object { $_.name -like $ListName } |
                        Select-Object -First 1 -ExpandProperty 'id'
        }

        switch ($AffinityCacheType) {
            'ScriptVariable' {
                if ($Affinity_Last_List) {
                    $Output = $Affinity_Last_List
                    break
                }
            }
            'EnvironmentVariable' {
                if ($env:AFFINITY_LAST_LISTS) {
                    $Output = $env:AFFINITY_LAST_LIST | ConvertFrom-CliXml
                    break
                }
            }
        }

        if ($Output.id -eq $ListID) { return $Output }
        else {
            # Do a separate API call (instead of filtering the List collection) in order to get the .fields[]
            # subarray so all output is congruent

            $Output = Invoke-AffinityAPIRequest -Method Get -Fragment ("lists/{0}" -f $ListID)

            switch ($AffinityCacheType) {
                'ScriptVariable' {
                    $script:Affinity_Last_List = $Output
                    break
                }
                'EnvironmentVariable' {
                    $env:AFFINITY_LAST_LIST = $Output | ConvertTo-CliXml
                    break
                }
            }

            return $Output
        }
    }
}
