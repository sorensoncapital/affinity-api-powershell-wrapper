<#
    .SYNOPSIS
        Exports Microsoft .NET objects froms PowerShell to a CliXml string.

    .DESCRIPTION
        The ConvertTo-CliXml command exports Microsoft .NET Framework objects from PowerShell to a CliXml string.

    .PARAMETER InputObject
        Specifies the object to be converted. Enter a variable that contains the objects, or type a command or expression that gets the objects. You can also pipe objects to ConvertTo-CliXml.

    .INPUTS
        object

    .OUTPUTS
        System.String

    .NOTES
        Help Author: Adam Najmanowicz, Michael West

    .LINK
        https://github.com/SitecorePowerShell/Console/

    .LINK
        ConvertFrom-CliXml

    .LINK
        ConvertFrom-Xml

    .LINK
        ConvertTo-Xml

    .LINK
        Export-CliXml

    .LINK
        Import-CliXml

    .EXAMPLE
        PS master:\> #Convert original item to xml
        PS master:\> $myCliXmlItem = Get-Item -Path master:\content\home | ConvertTo-CliXml
        PS master:\> #print the CliXml
        PS master:\> $myCliXmlItem
        PS master:\> #print the Item converted back from CliXml
        PS master:\> $myCliXmlItem | ConvertFrom-CliXml
#>
function ConvertTo-CliXml {
    param(
        [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [PSObject[]]$InputObject
    )
    begin {
        $type = [PSObject].Assembly.GetType('System.Management.Automation.Serializer')
        $ctor = $type.GetConstructor('instance,nonpublic', $null, @([System.Xml.XmlWriter]), $null)
        $sw = New-Object System.IO.StringWriter
        $xw = New-Object System.Xml.XmlTextWriter $sw
        $serializer = $ctor.Invoke($xw)
        #$method = $type.GetMethod('Serialize', 'nonpublic,instance', $null, [type[]]@([object]), $null)
    }
    process {
        try {
            [void]$type.InvokeMember("Serialize", "InvokeMethod,NonPublic,Instance", $null, $serializer, [object[]]@($InputObject))
        } catch {
            Write-Warning "Could not serialize $($InputObject.GetType()): $_"
        }
    }
    end {
        [void]$type.InvokeMember("Done", "InvokeMethod,NonPublic,Instance", $null, $serializer, @())
        $sw.ToString()
        $xw.Close()
        $sw.Dispose()
    }
}
