function ConvertFrom-Ini {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]
        $InputObject
    )

    begin {
        $ErrorActionPreference = 'Stop'
        $OutputObject = [pscustomobject]@{}
        $Converted = [ordered]@{}
    }

    process {
        try {
            switch -Regex ($InputObject) {
                '^(\s+)?;|^\s*$' {
                    #Skip comment or blank line
                }
                '^(\s+)?\[(?<Section>.*)\](\s+)?$' {
                    if ($Converted.Count -gt 0) {
                        $OutputObject | Add-Member -MemberType Noteproperty -Name $Section -Value $([pscustomobject]$Converted) -Force
                        $Converted = [ordered]@{}
                    }
                    $Section = $Matches.Section.Trim()
                }
                '^(?<Name>.*)\=(?<Value>.*)$' {
                    $Converted.Add($Matches.Name.Trim(), $Matches.Value.Trim())
                }
                default {
                    'Unexpected line: {0}' -f $_ | Write-Warning
                }
            }
        }
        catch {
            $PSCmdlet.ThrowTerminatingError($_)
        }
    }

    end {
        If ($Converted.Count -gt 0) {
            $OutputObject | Add-Member -MemberType Noteproperty -Name $Section -Value $([pscustomobject]$Converted) -Force
        }
        Write-Output $OutputObject
    }
}
