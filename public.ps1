Try {
    Remove-Item -Path .\dist
    $version = Get-Content .\.version
    $v = $version.Split('.')
    $v[-1] = ($v[-1] -As [int]) + 1
    $versionProposal = $v -Join '.'
    
    $version = Read-Host -Prompt "Version ($versionProposal)"
    $version = If ([string]::IsNullOrWhitespace($version)){$versionProposal} else {$version}
    If (-Not ($version -Match '(([0-9])+(\.){0,1})+')) {
        Write-Host "Version must be in the format x.x.x"
        Exit 1
    }
    
    Set-Content -Value $version -Path .\.version
    
    python setup.py sdist
    
    twine upload dist/*
} Catch {
    $version = Get-Content .\.version
    $v = $version.Split('.')
    $v[-1] = ($v[-1] -As [int]) - 1
    $version = $v -Join '.'
    Set-Content -Value $version -Path .\.version
    Write-Host $_.Exception.Message
}