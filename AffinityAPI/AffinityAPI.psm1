param(
    # Object cache type
    [Parameter(Mandatory = $false,
               Position = 0)]
    [ValidateSet('ScriptVariable','EnvironmentVariable')]
    [ValidateScript({
        if ($_ -eq 'EnvironmentVariable' -and $PSVersionTable.PSVersion -lt 5.1 ) { $false }
        else { $true }
    })]
    [string]
    $ObjectCacheType = $(
        if ($Env:AFFINITY_OBJECT_CACHE_TYPE) { $Env:AFFINITY_OBJECT_CACHE_TYPE }
        else { 'ScriptVariable' }
    ),

    # Setting cache type,
    [Parameter(Mandatory = $false,
               Position = 1)]
    [ValidateSet('ScriptVariable','EnvironmentVariable')]
    [ValidateScript({
        if ($_ -eq 'EnvironmentVariable' -and $PSVersionTable.PSVersion -lt 5.1 ) { $false }
        else { $true }
    })]
    [string]
    $SettingCacheType = $(
        if ($Env:AFFINITY_SETTING_CACHE_TYPE) { $Env:AFFINITY_SETTING_CACHE_TYPE }
        else { 'ScriptVariable' }
    ),

    # Setting object type,
    [Parameter(Mandatory = $false,
    Position = 2)]
    [ValidateSet('Credential','String')]
    [string]
    $SettingObjectType = $(
        if ($Env:AFFINITY_SETTING_OBJECT_TYPE) { $Env:AFFINITY_SETTING_OBJECT_TYPE }
        else { 'Credential' }
    )
)

# Get public and private function definition files
$private:Public  = @(
    Get-ChildItem -Path "$PSScriptRoot\Public" -Recurse -Filter "*.ps1" -ErrorAction SilentlyContinue
)
$private:Private = @(
    Get-ChildItem -Path "$PSScriptRoot\Private" -Recurse -Filter "*.ps1" -ErrorAction SilentlyContinue
)

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

# Initialize object cache type ('ScriptVariable' or 'EnvironmentVariable') based on args
# 'ScriptVariable' means that objects are cached as $script:var
# 'EnvironmentVariable' means that objects are cached as $env:var
# 'EnvironmentVariable' can be useful in certain types of deployments (Azure Functions)
# 'EnvironmentVariable' only available on PowerShell 5.1+
# Need to set TTL on the EnvironmentVariable cache

Set-Variable -Name AffinityObjectCacheType -Scope script -Option Constant -Value $ObjectCacheType
Set-Variable -Name AffinitySettingCacheType -Scope script -Option Constant -Value $SettingCacheType

# Initialize setting object type ('Credential' or 'String') based on args
# 'Credential' means that the API key is stored encrypted as a PSCredential
# 'String' means that the API key is stored unencrypted as a string
# 'String' can be useful in very secure deployments (Azure Functions), but is VERY INSECURE otherwise
Set-Variable -Name AffinitySettingObjectType -Scope script -Option Constant -Value $SettingObjectType

# Export only the functions using PowerShell standard verb-noun naming.
# Be sure to list each exported functions in the FunctionsToExport field of the module manifest file.
# This improves performance of command discovery in PowerShell.

Export-ModuleMember -Function $Public.basename

# Note: You cannot create cmdlets in a script module file, but you can import cmdlets from a binary module into a
# script module and re-export them from the script module.
