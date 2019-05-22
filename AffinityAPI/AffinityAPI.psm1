# Get public and private function definition files
$script:Public  = @( Get-ChildItem -Path "$PSScriptRoot\Public" -Recurse -Filter "*.ps1" -ErrorAction SilentlyContinue )
$script:Private = @( Get-ChildItem -Path "$PSScriptRoot\Private" -Recurse -Filter "*.ps1" -ErrorAction SilentlyContinue )

# Dot source the files
Foreach($import in @($Public + $Private)) {
    Try { . $import.fullname }
    Catch { Write-Error -Message "Failed to import function $($import.fullname): $_" }
}

# Initialize standard base URL
Set-Variable -Name AffinityStandardBaseUrl -Scope script -Option Constant -Value "https://api.affinity.co"

# Initialize standard field value types
Set-Variable -Name AffinityStandardFieldValueTypes -Scope script -Option Constant -Value @(
    "Person",
    "Organization",
    "Dropdown",
    "Number",
    "Date",
    "Location",
    "Text",
    "Ranked Dropdown"
)

# Select type of cache ('ScriptVariable' or 'EnvironmentVariable')
#   'EnvironmentVariable' can be useful in certain types of deployments (Azure Functions)
#   Eventually need to add a config file instead of these ham-fisted defaults
Set-Variable -Name AffinityCacheType -Scope script -Option Constant -Value @{
    LastList                        = 'EnvironmentVariable'
    AllLists                        = 'EnvironmentVariable'
    OrganizationGlobalFieldHeaders  = 'EnvironmentVariable'
    Setting                         = 'ScriptVariable'
}

# Export only the functions using PowerShell standard verb-noun naming.
# Be sure to list each exported functions in the FunctionsToExport field of the module manifest file.
# This improves performance of command discovery in PowerShell.

Export-ModuleMember -Function $Public.basename

# Note: You cannot create cmdlets in a script module file, but you can import cmdlets from a binary module into a script module and re-export them from the script module.
