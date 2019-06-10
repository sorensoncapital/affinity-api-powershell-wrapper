@{
    # Use Severity when you want to limit the generated diagnostic records to a
    # subset of: Error, Warning and Information.
    # Uncomment the following line if you only want Errors and Warnings but
    # not Information diagnostic records.
    # Severity = @('Error','Warning')

    # Use IncludeRules when you want to run only a subset of the default rule set.
    #IncludeRules = @('PSAvoidDefaultValueSwitchParameter',
    #                 'PSMissingModuleManifestField',
    #                 'PSReservedCmdletChar',
    #                 'PSReservedParams',
    #                 'PSShouldProcess',
    #                 'PSUseApprovedVerbs',
    #                 'PSUseDeclaredVarsMoreThanAssigments')

    # Use ExcludeRules when you want to run most of the default set of rules except
    # for a few rules you wish to "exclude".  Note: if a rule is in both IncludeRules
    # and ExcludeRules, the rule will be excluded.
    #ExcludeRules = @()

    # You can use the following entry to supply parameters to rules that take parameters.
    # For instance, the PSAvoidUsingCmdletAliases rule takes a whitelist for aliases you
    # want to allow.
    Rules = @{
        # Do not flag 'cd' alias
        # PSAvoidUsingCmdletAliases = @{Whitelist = @('cd')}

        # Check syntax for target verions
        PSUseCompatibleSyntax = @{
            Enable = $true
            TargetVerions = @('3.0', '4.0', '5.0', '5.1', '6.0', '6.1', '6.2')
        }

        # Check used cmdlets for compatibility on PowerShell Core, version 6.0.0-alpha, on Linux
        PSUseCompatibleCmdlets = @{
            Enable = $true
            Compatibility = @(
                'win-48_x64_10.0.17763.0_5.1.17763.316_x64_4.0.30319.42000_framework',
                'win-48_x64_10.0.17763.0_6.1.3_x64_4.0.30319.42000_core',
                'ubuntu_x64_18.04_6.1.3_x64_4.0.30319.42000_core',
                'macos_x64_18.2.0.0_6.2.0_x64_4.0.30319.42000_core',
                'azurefunctions'
            )
        }
    }
}