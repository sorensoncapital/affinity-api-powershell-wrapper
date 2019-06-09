Import-Module ..\affinity-api-powershell-wrapper\AffinityAPI\AffinityAPI.psd1 -ErrorAction Stop

InModuleScope AffinityAPI {
    Describe -Name 'Test-NestedCollection' -Tag 'Unit' {
        It 'Returns $true if nested hashtable exists' {
            $NestedHashtable = @{
                a = 'a'
                b = 'b'
                c = @{
                    1 = '1'
                    2 = '2'
                    3 = '3'
                }
            }

            Test-NestedContainer -Collection $NestedHashtable | Should -BeTrue
        }

        It 'Returns $true if nested array exists' {
            $NestedArray = @{
                a = 'a'
                b = 'b'
                c = @(
                    1,
                    2,
                    3
                )
            }

            Test-NestedContainer -Collection $NestedArray | Should -BeTrue
        }

        It 'Returns $false if no nested container exists' {
            $FlatHashtable = @{
                a = 'a'
                b = 'b'
                c = 'c'
            }

            Test-NestedContainer -Collection $FlatHashtable | Should -BeFalse
        }

        It 'Throws error if input is not hashtable' {
            $Array = @(
                1,
                2,
                3
            )

            { Test-NestedContainer -Collection $Array } | Should -Throw
        }

        It 'Throws error if input is empty' {
            $EmptyHashtable = @{ }

            { Test-NestedContainer -Collection $EmptyHashtable } | Should -Throw
        }

        It 'Throws error if input is null' {
            $NullInput = $null

            { Test-NestedContainer -Collection $NullInput } | Should -Throw
        }
    }
}