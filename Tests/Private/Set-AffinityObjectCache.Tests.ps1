Get-Module AffinityAPI | Remove-Module -ErrorAction Silent
Import-Module ..\affinity-api-powershell-wrapper\AffinityAPI\AffinityAPI.psd1 -Force -ErrorAction Stop

InModuleScope AffinityAPI {
    Describe -Name 'Set-AffinityObjectCache' -Tag 'Unit' {
        Context -Name 'Script Variable' {
            $VariableName = 'VarName'
            Mock ConvertTo-EnvironmentVariableCase { return 'VAR_NAME' }

            $CacheType = 'ScriptVariable'
            $VariableValue = 'VarValue'

            $Result = Set-AffinityObjectCache -Name $VariableName -CacheType $CacheType -Value $VariableValue

            It 'Returns $true' {
                $Result | Should -BeTrue
            }
            It 'Sets a script variable' {
                $script:VarName | Should -BeExactly $VariableValue
            }
            It 'Does not set a global variable' {
                { $global:VarName } | Should -Not -Exist
            }
        }

        $TypeTests = @(
            @{ type = 'Short String' ; startval = 'VarValue'      ; endval = 'VarValue'      ; res = $true  },
            @{ type = 'Long String'  ; startval = 'V' * 32768     ; endval = 'V' * 32768     ; res = $false },
            @{ type = 'Int'          ; startval = 1000            ; endval = 1000            ; res = $true  },
            @{ type = 'Long'         ; startval = [long]1000      ; endval = [long]1000      ; res = $true  },
            @{ type = 'Decimal'      ; startval = [decimal]0.0001 ; endval = [decimal]0.0001 ; res = $true  },
            @{ type = 'Single'       ; startval = [single]0.0001  ; endval = [Single]0.0001  ; res = $true  },
            @{
                type = 'Array'
                startval = @(1, 2, 3)
                endval = [System.Management.Automation.PSSerializer]::Serialize(@(1, 2, 3), 100)
                res = $true
            },
            @{
                type = 'Small Hashtable'
                startval = @{ a = 1; b = 2; c = 3 }
                endval = [System.Management.Automation.PSSerializer]::Serialize(@{ a = 1; b = 2; c = 3 }, 100)
                res = $true
            },
            @{
                type = 'Large Hashtable'
                startval = @{ a = '1' * 32768 }
                endval = [System.Management.Automation.PSSerializer]::Serialize(@{ a = '1' * 32768 }, 100)
                res = $false
            },
            @{
                type = 'PSObject'
                startval = [PSCustomObject]@{ Name = 'Value' }
                endval = [System.Management.Automation.PSSerializer]::Serialize([PSCustomObject]@{ Name = 'Value' }, 100)
                res = $true
            }
        )

        foreach ($test in $TypeTests) {
            Context -Name "Environment Variable - $($test.type)" {
                $VariableName = 'VarName'
                Mock ConvertTo-EnvironmentVariableCase { return 'VAR_NAME' }

                Mock Set-Content {} -Verifiable -ParameterFilter {
                    $Path -eq "env:VAR_NAME" -and $Value -eq $test.endval
                }

                $Result = Set-AffinityObjectCache -Name $VariableName -CacheType 'EnvironmentVariable' -Value $test.startval

                if ($test.res) {
                    It "$($test.type): Returns `$true" { $Result | Should -BeTrue }
                    It "$($test.type): Sets an environment variable" {
                        { Assert-VerifiableMock } | Should -Not -Throw
                    }
                }
                else {
                    It "$($test.type): Returns `$false" { $Result | Should -BeFalse }
                    It "$($test.type): Does not set an environment variable" {
                        { Assert-VerifiableMock } | Should -Throw
                    }
                }
            }
        }

        Context -Name 'Environment Variable - Unsupported Powershell Version' {
            # Need to code
        }
    }
}