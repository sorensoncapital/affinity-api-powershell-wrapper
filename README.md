# AffinityAPI

The is a PowerShell wrapper for the [Affinity](https://www.affinity.co) API. The aim of the project is to be able to provide robust coverage of the all available REST methods, while handling authentication, caching, etc. in a PowerShell-native style.

## Getting Started

Before undergoing a scripting project, it is advised to spend some time reviewing Affinity's data model and API documentation that can be found [here](https://api-docs.affinity.co).

### Prerequisites

There are two prerequisites to run use this module:
1. **Affinity API Key**. Can be generated by logging into Affinity and going to *Settings* > *API* > *Generate*
2. **Powershell**. Either Windows PowerShell 5.1+ or PowerShell Core 6.0+ is fine

### Installing

There are two main methods to install this PowerShell module:

#### 1) PowerShell Gallery (preferred)

```powershell
# If the user has admin rights:
Install-Module AffinityAPI
# If the user has user rights:
Install-Module AffinityAPI -Scope CurrentUser
# If the user has no rights:
Save-Module AffinityAPI
```
#### 2) Manual

```
Download Zip then unzip AffinityAPI folder to a PowerShell module folder
```

### Usage
Once the module is installed, usage is pretty straightforward

```powershell
# First, import AffinityAPI
# Alternatively, rely on module auto-loading if module is properly installed
Import-Module AffinityAPI

# Second, export the Affinity API key to a .cred file
# This needs to be run once on every new machine / user name
Set-AffinitySetting         # Asks user for API key
Export-AffinitySetting      # Saves down encrypted API key

# Third, import the Affinity API key from the .cred file
# This needs to be run in every script to authenticate the user
Import-AffinitySetting

# Finally, start scripting
$ListEntries = Get-AffinityListEntry -ListName 'List'

foreach ($entry in $ListEntries) {
    $EntryFieldValues = Get-AffinityFieldValue -OrganizationID $entry.entity.id -ListID $entry.list_id -Expand
    Write-Output $EntryFieldValues.'Status'.field_value
}
```

## Authors

* **Burke Davis** - *Initial work* - [burkasaurusrex](https://github.com/burkasaurusrex)

See also the list of [contributors](https://github.com/sorensoncapital/affinity-api-powershell-wrapper/graphs/contributors) who participated in this project.

## License

This project is licensed under the MIT License - see the [license](LICENSE) file for details

## Acknowledgments

* [Adam Najmanowicz](https://blog.najmanowicz.com) and [Michael West](https://michaellwest.blogspot.com) at [SitecorePowerShell](https://github.com/SitecorePowerShell) for the [ConvertFrom-CliXml](https://github.com/SitecorePowerShell/Console/blob/master/Modules/SPE/ConvertFrom-CliXml.ps1) and [ConvertTo-CliXml](https://github.com/SitecorePowerShell/Console/blob/master/Modules/SPE/ConvertTo-CliXml.ps1) modules
