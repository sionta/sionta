[CmdletBinding()]
param (
    [Parameter(Mandatory = $true, Position = 0)]
    [Alias('u', 'owner')]
    [string]$userName,
    [Parameter(ValueFromPipeline = $true)]
    [Alias('e', 'ignore')]
    [string[]]$Excludes,
    [Alias('f', 'force')]
    [switch]$hardReset
)

try {
    $repos = gh repo list $userName --fork --json name --jq '.[].name'
    $params = if ($hardReset) { '--force' } else { $null }
    foreach ($repo in $repos) {
        if ($repo -notin $Excludes) {
            Write-Host "Synchronizing '$userName/$repo'..."
            gh repo sync "$userName/$repo" $params
        }
    }
} catch {
    $errorMessage = $_.Exception.Message
    Write-Error "Error during synchronization: $errorMessage"
    exit 1
}
