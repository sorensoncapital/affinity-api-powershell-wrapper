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
                   DefaultParameterSetName = 'OrganizationID',
                   HelpUri = 'https://api-docs.affinity.co/#get-field-values')]
    [OutputType([Hashtable])]
    Param
    (
        # Affinity Organization ID
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ParameterSetName ='OrganizationID')]
        [Int]
        $OrganizationID,

        # Affinity Opportunity ID
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ParameterSetName ='OpportunityID')]
        [Int]
        $OpportunityID,

        # Affinity List Entry ID
        [Parameter(Mandatory = $true,
                   Position = 0,
                   ParameterSetName = 'ListEntryID')]
        [Int]
        $ListEntryID
    )

    Begin {
        # Check simple cache     
        if (!$Affinity_Last_List.fields) { <# Get Affinity List. Most likely need to move this to params #> }

        # Get list field headers
        $ListFieldHeaders = $Affinity_Last_List.fields

        # Add list id and list name to list field headers
        for ($i = 0; $i -lt $ListFieldHeaders.count; $i++) {
            $ListFieldHeaders[$i] | Add-Member NoteProperty 'list_id' $Affinity_Last_List.id -Force
            $ListFieldHeaders[$i] | Add-Member NoteProperty 'list_name' $Affinity_Last_List.name -Force
        }
    }
    Process {
        # Instantiate Field Headers
        $FieldHeaders = $ListFieldHeaders

        if ($OrganizationID) {
            # Check simple cache
            if (!$Affinity_Last_OrganizationGlobalFieldHeaders) { Get-AffinityOrganizationGlobalFieldHeaders | Out-Null }   
            
            # Combine all field headers
            $FieldHeaders = $FieldHeaders + $Affinity_Last_OrganizationGlobalFieldHeaders

            # Retrieve field values for OrganizationID
            $FieldValues = Invoke-AffinityAPIRequest -Method Get -Fragment ("field-values?organization_id={0}" -f $OrganizationID)
        } elseif ($OpportunityID) {
            # Returns Fields 
            $FieldValuesWithHeaders = Get-AffinityOpportunity -OpportunityID $OpportunityID

            # Retreive field values for OpportunityID
            $FieldValues = Invoke-AffinityAPIRequest -Method Get -Fragment ("field-values?opportunity_id={0}" -f $OpportunityID)
        } elseif ($ListEntryID) {
            # Retreive field values for OpportunityID
            $FieldValues = Invoke-AffinityAPIRequest -Method Get -Fragment ("field-values?list_entry_id={0}" -f $ListEntryID)            
        }

        # Instantiate output hashtable
        $FieldValuesOutput = @{}

        # Really need to refactor this code ...
        # Investigate using Join-Object (https://www.powershellgallery.com/packages/Join/2.3.1) then Group-Object
        
        # Reformat Headers with Values
        if ($FieldValuesWithHeaders) {
            foreach ($field in $FieldValuesWithHeaders) {
                
            }
        }

        # Combine Headers with Values
        if ($FieldHeaders -and $FieldValues) {
            foreach ($fieldheader in $FieldHeaders) {
                $fieldvalue = @{
                    'field_id' = $fieldheader.id
                    'value_type' = $fieldheader.value_type
                    'value_type_name' = $AffinityFieldValueTypes[$fieldheader.value_type]
                    'allows_multiple' = $fieldheader.allows_multiple
                }

                if ($fieldheader.list_id -or $fieldheader.list_name) {
                    $fieldvalue.Add('list_id', $fieldheader.list_id)
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
                    Remove-Variable multiplefieldvalues
                }
                else {
                    $singlefieldvalue = $FieldValues | `
                                        Where-Object { $_.field_id -eq $fieldvalue.field_id } | `
                                        Select-Object -First 1

                    $fieldvalue.Add('field_value_id', $singlefieldvalue.id)
                    $fieldvalue.Add('field_value', $singlefieldvalue.value)
                    Remove-Variable singlefieldvalue
                }

                $FieldValuesOutput.Add($fieldheader.name, $fieldvalue)
                Remove-Variable fieldvalue
            }

            Remove-Variable FieldHeaders, FieldValues
        }

        return $FieldValuesOutput
    }
}