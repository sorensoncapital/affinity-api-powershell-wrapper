<#
.Synopsis
    Read field-values for an organization_id, opportunity_id, or list_entry_id
.DESCRIPTION
    This function returns a PSObject containing all the field-values related to a given key.

    Without the -Expand switch, the function returns the raw field values from Affinity, which is a bit cumbersome
    to use without a detailed understanding of Affinity's data model. Leveraging the -Expand switch, the function
    returns a rich PSObject that contains field name and other metadata in addition to the field values.
.PARAMETER OrganizationID
    The organization_id or entity.id from Affinity
.PARAMETER OpportunityID
    The opportunity_id from Affinity
.PARAMETER ListEntryID
    The list_entry_id from Affinity
.PARAMETER ListID
    The list_id from Affinity
.PARAMETER Expand
    Set switch to combine field names and other metadata in rich PSObject
.EXAMPLE
    $ListEntries = Get-AffinityListEntry -ListName 'List'

    foreach ($entry in $ListEntries) {
        $EntryFieldValues = Get-AffinityFieldValue -OrganizationID $entry.entity.id -ListID $entry.list_id -Expand
        Write-Output $EntryFieldValues.'Status'.field_value
    }
.OUTPUTS
    System.Management.Automation.PSObject
.NOTES
    Need to implement person_id. Need to test opportunity_id, list_entry_id.
.LINK
    https://api-docs.affinity.co/#fields
.LINK
    https://api-docs.affinity.co/#field-values
.LINK
    https://api-docs.affinity.co/#the-field-value-resource
.LINK
    https://api-docs.affinity.co/#get-field-values
#>
function Get-AffinityFieldValue
{
    [CmdletBinding(PositionalBinding = $true,
                   DefaultParameterSetName = 'OrganizationIDandListID')]
    [OutputType([System.Management.Automation.PSObject])]
    Param
    (
        # Affinity Organization ID
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ParameterSetName ='OrganizationID')]
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ParameterSetName ='OrganizationIDandListID')]
        [ValidateNotNullOrEmpty()]
        [long]
        $OrganizationID,

        # Affinity Opportunity ID
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ParameterSetName ='OpportunityID')]
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ParameterSetName ='OpportunityIDandListID')]
        [ValidateNotNullOrEmpty()]
        [long]
        $OpportunityID,

        # Affinity List Entry ID
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ParameterSetName = 'ListEntryID')]
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ParameterSetName = 'ListEntryIDandListID')]
        [ValidateNotNullOrEmpty()]
        [long]
        $ListEntryID,

        # Affinity List ID
        [Parameter(Mandatory = $true,
                   Position = 1,
                   ParameterSetName = 'OrganizationIDandListID')]
        [Parameter(Mandatory = $true,
                   Position = 1,
                   ParameterSetName = 'OpportunityIDandListID')]
        [Parameter(Mandatory = $true,
                   Position = 1,
                   ParameterSetName = 'ListEntryIDandListID')]
        [ValidateNotNullOrEmpty()]
        [long]
        $ListID,

        # Expand ouput with field headers
        [Parameter(Mandatory = $false,
                   Position = 2,
                   ParameterSetName = 'OrganizationIDandListID')]
        [Parameter(Mandatory = $false,
                   Position = 2,
                   ParameterSetName = 'OpportunityIDandListID')]
        [Parameter(Mandatory = $false,
                   Position = 2,
                   ParameterSetName = 'ListEntryIDandListID')]
        [switch]
        $Expand
    )

    Begin {  }

    Process {
        # Set parameters for API call
        switch -Wildcard ($PSCmdlet.ParameterSetName) {
            "OrganizationID*" {
                # Parameters to retreive field values for OrganizationID
                $IAARParameters = @{ Fragment = ("field-values?organization_id={0}" -f $OrganizationID) }
                break
            }
            "OpportunityID*" {
                # Parameters to retreive field values for OpportunityID
                $IAARParameters = @{ Fragment = ("field-values?opportunity_id={0}" -f $OpportunityID) }
                break
            }
            "ListEntryID*" {
                # Parameters to retreive field values for OpportunityID
                $IAARParameters = @{ Fragment = ("field-values?list_entry_id={0}" -f $ListEntryID) }
                break
            }
            Default { <# Throw Error #> }
        }

        # Retrieve field values
        $FieldValues = Invoke-AffinityAPIRequest -Method Get @IAARParameters

        if ($Expand) {
            $FieldHeaders = $null

            switch -Wildcard ($PSCmdlet.ParameterSetName) {
                "OrganizationID*" {
                    # Add organization global field headers to field headers to be processed
                    $FieldHeaders += (Get-AffinityOrganizationGlobalFieldHeader)
                }
                "*ListID" {
                    # Get list field headers
                    $ListFieldHeaders = (Get-AffinityList -ListID $ListID).fields

                    # Add list id and list name to list field headers
                    for ($i = 0; $i -lt $ListFieldHeaders.count; $i++) {
                        $ListFieldHeaders[$i] | Add-Member NoteProperty 'list_id' $Affinity_Last_List.id -Force
                        $ListFieldHeaders[$i] | Add-Member NoteProperty 'list_name' $Affinity_Last_List.name -Force
                    }

                    # Add list field headers to field headers to be processed
                    $FieldHeaders += $ListFieldHeaders
                }
            }

            # Instantiate output hashtable
            $ExpandedFieldValues = @{}

            # Really need to refactor this code ...
            # Investigate using Join-Object (https://www.powershellgallery.com/packages/Join/2.3.1) then Group-Object

            # Combine Headers with Values
            if ($FieldHeaders -and $FieldValues) {
                foreach ($fieldheader in $FieldHeaders) {
                    $fieldvalue = @{
                        'field_id' = $fieldheader.id
                        'value_type' = $fieldheader.value_type
                        'value_type_name' = $AffinityStandardFieldValueTypes[$fieldheader.value_type]
                        'allows_multiple' = $fieldheader.allows_multiple
                    }

                    if ($fieldheader.list_id) {
                        $fieldvalue.Add('list_id', $fieldheader.list_id)
                    }

                    if ($fieldheader.list_name) {
                        $fieldvalue.Add('list_name', $fieldheader.list_name)
                    }

                    if ($fieldvalue.value_type_name -ilike "*dropdown*" -and $fieldheader.dropdown_options) {
                        $fieldvalue.Add('dropdown_options', $fieldheader.dropdown_options)
                    }

                    if ($fieldvalue.allows_multiple) {
                        $multiplefieldvalues = $FieldValues | `
                                            Where-Object { $_.field_id -eq $fieldvalue.field_id } | `
                                            Select-Object @{N='field_value_id'; E={$_.id}}, @{N='field_value'; E={$_.value}}

                        $fieldvalue.Add('field_values', $multiplefieldvalues)
                        $multiplefieldvalues = $null
                    }
                    else {
                        $singlefieldvalue = $FieldValues | `
                                            Where-Object { $_.field_id -eq $fieldvalue.field_id } | `
                                            Select-Object -First 1

                        $fieldvalue.Add('field_value_id', $singlefieldvalue.id)
                        $fieldvalue.Add('field_value', $singlefieldvalue.value)
                        $singlefieldvalue = $null
                    }

                    $ExpandedFieldValues.Add($fieldheader.name, $fieldvalue)
                    $fieldvalue = @{}
                }

                $FieldHeaders = $FieldValues = $null
            }

            return $ExpandedFieldValues
        }
        else { return $FieldValues }
    }
}
