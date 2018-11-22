function ConvertFrom-Ini {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
        [Alias('FullName', 'PSPath')]
        [string]
        $Path
    )
    $ErrorActionPreference = 'Stop'
    try {
        $Content = Get-Content -Path $Path | Where-Object {$_ -notmatch '^(\s+)?;|^\s*$'}

        $ConvertedContent = [pscustomobject]@{}
        $Data = [ordered]@{}

        switch -Regex ($Content) {
            '^(\s+)?\[(?<Section>.*)\](\s+)?$' {
                if ($Data.Count -gt 0) {
                    $ConvertedContent | Add-Member -MemberType Noteproperty -Name $Section -Value $([pscustomobject]$Data) -Force
                    $Data = [ordered]@{}
                }
                $Section = $Matches.Section.Trim()
            }
            '^(?<Name>.*)\=(?<Value>.*)$' {
                $Data.Add($Matches.Name.Trim(), $Matches.Value.Trim())
            }
            default {
                'Unexpected line: {0}' -f $_ | Write-Warning
            }
        }
        If ($Data.count -gt 0) {
            $ConvertedContent | Add-Member -MemberType Noteproperty -Name $Section -Value $([pscustomobject]$Data) -Force
        }
    }
    catch {
        $PSCmdlet.ThrowTerminatingError($_)
    }
    finally {
        Write-Output $ConvertedContent
    }
}
