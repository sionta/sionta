param(
    [alias('e')]
    [string[]]$excludes
)
try {
    $json = gh repo list --fork --json nameWithOwner
    $repos = (ConvertFrom-Json $json).nameWithOwner

    foreach ($repo in $repos) {
        if ($repo -notin $excludes) {
            gh repo sync $repo
        }
    }
} catch {
    $errorMessage = $_.Exception.Message
    Write-Output "Error during synchronization: $errorMessage"
    exit 2
}
