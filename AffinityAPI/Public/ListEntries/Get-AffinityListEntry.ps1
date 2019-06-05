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
    https://api-docs.affinity.co/#get-all-list-entries
.LINK
    https://api-docs.affinity.co/#get-a-specific-list-entry
#>
function Get-AffinityListEntry
{
    [CmdletBinding(PositionalBinding = $true,
                   DefaultParameterSetName = 'ListName')]
    [OutputType([System.Management.Automation.PSObject[]], ParameterSetName=('ListName', 'ListID'))]
    [OutputType([System.Management.Automation.PSObject[]],
                ParameterSetName=('ListNameandListEntryID', 'ListIDandListEntryID'))]
    Param
    (
        # Affinity List Name
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ParameterSetName = 'ListName')]
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ParameterSetName = 'ListNameandListEntryID')]
        [ValidateNotNullOrEmpty()]
        [string]
        $ListName,

        # Affinity list_id
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ParameterSetName = 'ListID')]
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ParameterSetName = 'ListIDandListEntryID')]
        [ValidateNotNullOrEmpty()]
        [long]
        $ListID,

        # Affinity list_entry_id
        [Parameter(Mandatory = $true,
                   Position = 1,
                   ParameterSetName = 'ListNameandListEntryID')]
        [Parameter(Mandatory = $true,
                   Position = 1,
                   ParameterSetName = 'ListIDandListEntryID')]
        [ValidateNotNullOrEmpty()]
        [long]
        $ListEntryID
    )

    Process {
        switch -Wildcard ($PSCmdlet.ParameterSetName) {
            "ListName*" {
                $ListID = (Get-AffinityList -ListName $ListName).id
            }
            { 'ListName', 'ListID' -contains $_ } {
                $Fragment = "lists/{0}/list-entries" -f $ListID
                break
            }
            "*ListEntryID" {
                $Fragment = "lists/{0}/list-entries/{1}" -f $ListID, $ListEntryID
                break
            }
            Default { throw [System.NotSupportedException] "ParameterSet not developed" }
        }

        Invoke-AffinityAPIRequest -Method Get -Fragment $Fragment
    }
}
