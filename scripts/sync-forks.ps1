[CmdletBinding()]
param (
    [Parameter(Mandatory = $true, Position = 0)]
    [Alias('u', 'owner')]

    [string]$userName,
    [Parameter(ValueFromPipeline = $true)]

    [Alias('e', 'ignore')]
    [string[]]$Excludes,

    [Alias('c', 'clone')]
    [switch]$cloneRepo,

    [Alias('f', 'force')]
    [switch]$hardReset
)

try {
    $repos = gh repo list $userName --fork --json name --jq '.[].name'
    $params = if ($hardReset) { '--force' } else { $null }
    foreach ($repo in $repos) {
        if ($repo -notin $Excludes) {
            if ($cloneRepo) {
                if (Test-Path "$repo" -PathType Container) {
                    Write-Host "Fetch and pulling '$userName/$repo'..."
                    Push-Location "$repo"
                    git fetch && git pull
                    Pop-Location
                }
                else {
                    Write-Host "Cloning '$userName/$repo'..."
                    gh repo clone "$userName/$repo"
                }
            }
            else {
                Write-Host "Synchronizing '$userName/$repo'..."
                gh repo sync "$userName/$repo" $params

            }
        }
    }
}
catch {
    $errorMessage = $_.Exception.Message
    Write-Error "Error during synchronization: $errorMessage"
    exit 1
}
