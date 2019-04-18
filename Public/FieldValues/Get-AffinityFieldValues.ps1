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
   Need to implement organization name search, person_id (and person_name), opportunity_id (and opportunity_name), list_entry_id (and list_entry_name?)
#>
function Get-AffinityFieldValues
{
    [CmdletBinding(PositionalBinding = $true,
                   DefaultParameterSetName = 'OrganizationIDandListID',
                   HelpUri = 'https://api-docs.affinity.co/#get-field-values')]
    [OutputType([Hashtable])]
    Param
    (
        # Affinity Organization ID
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ParameterSetName ='OrganizationID')]
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ParameterSetName ='OrganizationIDandListID')]
        [Int]
        $OrganizationID,

        # Affinity Opportunity ID
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ParameterSetName ='OpportunityID')]
                # Affinity Opportunity ID
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ParameterSetName ='OpportunityIDandListID')]
        [Int]
        $OpportunityID,

        # Affinity List Entry ID
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ParameterSetName = 'ListEntryID')]
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ParameterSetName = 'ListEntryIDandListID')]
        [Int]
        $ListEntryID,

        [Parameter(Mandatory = $true,
                   Position = 1,
                   ParameterSetName = 'OrganizationIDandListID')]
        [Parameter(Mandatory = $true,
                   Position = 1,
                   ParameterSetName = 'OpportunityIDandListID')]
        [Parameter(Mandatory = $true,
                   Position = 1,
                   ParameterSetName = 'ListEntryIDandListID')]
        [Int]
        $ListID,

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
                    # Check simple cache for organization global field headers
                    if (!$Affinity_Last_OrganizationGlobalFieldHeaders) {
                        Get-AffinityOrganizationGlobalFieldHeaders | Out-Null
                    }

                    # Add organization global field headers to field headers to be processed
                    $FieldHeaders += $Affinity_Last_OrganizationGlobalFieldHeaders
                }
                "*ListID" {
                    # Check simple cache for list
                    if ($Affinity_Last_List.id -ne $ListID) {
                        Get-AffinityList -ListID $ListID | Out-Null
                    }

                    # Get list field headers
                    $ListFieldHeaders = $Affinity_Last_List.fields

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
            $FieldValuesOutput = @{}

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

                    $FieldValuesOutput.Add($fieldheader.name, $fieldvalue)
                    $fieldvalue = @{}
                }

                $FieldHeaders = $FieldValues = $null
            }

            return $FieldValuesOutput
        }
        else { return $FieldValues }
    }
}
