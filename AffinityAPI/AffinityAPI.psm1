param(
    # Cache type
    [Parameter(Mandatory = $false,
               Position = 0)]
    [ValidateSet('ScriptVariable','EnvironmentVariable')]
    [string]
    $private:CacheType = 'ScriptVariable'
)

# Get public and private function definition files
$private:Public  = @( Get-ChildItem -Path "$PSScriptRoot\Public" -Recurse -Filter "*.ps1" -ErrorAction SilentlyContinue )
$private:Private = @( Get-ChildItem -Path "$PSScriptRoot\Private" -Recurse -Filter "*.ps1" -ErrorAction SilentlyContinue )

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

# Set cache type ('ScriptVariable' or 'EnvironmentVariable') based on args
# 'EnvironmentVariable' can be useful in certain types of deployments (Azure Functions)
# Need to set TTL on the EnvironmentVariable cache

switch ($CacheType) {
    'EnvironmentVariable' {
        Set-Variable -Name AffinityCacheType -Scope script -Option Constant -Value @{
            LastList                        = 'EnvironmentVariable'
            AllLists                        = 'EnvironmentVariable'
            OrganizationGlobalFieldHeaders  = 'EnvironmentVariable'
            Setting                         = 'ScriptVariable'      # Needs to be ScriptVariable
        }
        break
    }
    Default {
        Set-Variable -Name AffinityCacheType -Scope script -Option Constant -Value @{
            LastList                        = 'ScriptVariable'
            AllLists                        = 'ScriptVariable'
            OrganizationGlobalFieldHeaders  = 'ScriptVariable'
            Setting                         = 'ScriptVariable'
        }
    }
}

# Export only the functions using PowerShell standard verb-noun naming.
# Be sure to list each exported functions in the FunctionsToExport field of the module manifest file.
# This improves performance of command discovery in PowerShell.

Export-ModuleMember -Function $Public.basename

# Note: You cannot create cmdlets in a script module file, but you can import cmdlets from a binary module into a script module and re-export them from the script module.
