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
                $Output = Get-AffinityObjectCache -Name 'AffinityAllLists'

                # Call API if lists are not available in simple cache
                if (!$Output) {
                    $Output = Invoke-AffinityAPIRequest -Method Get -Fragment 'lists'
                    Set-AffinityObjectCache -Name 'AffinityAllLists' -Value $Output
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
                $Output = Get-AffinityObjectCache -Name AffinityLastList

                # Call API if last list is not available in the cache
                if (!$Output -or $Output.id -ne $ListID) {
                    # Do a separate API call (instead of filtering the List collection) in order to get the
                    # .fields[] subarray and so all output is congruent

                    $Output = Invoke-AffinityAPIRequest -Method Get -Fragment ("lists/{0}" -f $ListID)
                    Set-AffinityObjectCache -Name 'AffinityLastList' -Value $Output
                }

                return $Output
            }
        }
    }
}
