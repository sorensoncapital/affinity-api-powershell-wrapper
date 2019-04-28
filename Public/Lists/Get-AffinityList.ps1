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
    https://api-docs.affinity.co/#get-all-lists'
.LINK
    https://api-docs.affinity.co/#get-a-specific-list
#>
function Get-AffinityList
{
    [CmdletBinding(PositionalBinding = $true,
                   DefaultParameterSetName = 'AllLists')]
    [OutputType([System.Management.Automation.PSObject])]
    Param
    (
        # Affinity List Name
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ParameterSetName = 'ListNameList')]
        [string]
        $ListName,

        # Affinity List ID
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ParameterSetName = 'ListIDList')]
        [long]
        $ListID
    )

    Process {
        switch -Wildcard ($PSCmdlet.ParameterSetName) {
            "*Lists" {
                # Check simple cache for lists
                switch ($AffinityCacheType.AllLists) {
                    'ScriptVariable' {
                        if ($AffinityAllLists) {
                            $Output = $AffinityAllLists
                            break
                        }
                    }
                    'EnvironmentVariable' {
                        if ($env:AFFINITY_ALL_LISTS) {
                            $EnvInput = $env:AFFINITY_ALL_LISTS | ConvertFrom-CliXml

                            if (($EnvInput | Measure-Object).Count -gt 0) { $Output = $EnvInput }

                            break
                        }
                    }
                }

                # Call API if lists are not available in simple cache
                if (!$Output) {
                    $Output = Invoke-AffinityAPIRequest -Method Get -Fragment "lists"

                    # Set cache
                    switch ($AffinityCacheType.AllLists) {
                        'ScriptVariable' {
                            $script:AffinityAllLists = $Output
                            break
                        }
                        'EnvironmentVariable' {
                            $EnvOutput = $Output | ConvertTo-CliXml

                            if ($EnvOutput.length -le 32767) {
                                $env:AFFINITY_ALL_LISTS = $EnvOutput
                            }

                            break
                        }
                    }
                }

                return $Output
            }
            "*List" {
                # Get List ID if List Name is provided
                if ($ListName) {
                    $ListID = Get-AffinityList |
                                  Where-Object { $_.name -like $ListName } |
                                  Select-Object -First 1 -ExpandProperty 'id'
                }

                # Check simple cache for the last list
                switch ($AffinityCacheType.LastList) {
                    'ScriptVariable' {
                        if ($AffinityLastList) {
                            $Output = $AffinityLastList
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
                    switch ($AffinityCacheType.LastList) {
                        'ScriptVariable' {
                            $script:AffinityLastList = $Output
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
    }
}
