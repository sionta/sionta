[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [Alias('n', 'bn', 'name')]
    [string]$BaseName,

    [Alias('f')]
    [switch]$Force
)

$words = ($BaseName -replace "[/\-\\_]", " ") -split " "
$camelCaseWords = foreach ($word in $words) {
    $word.Substring(0, 1).ToUpper() + $word.Substring(1).ToLower()
}
$camelCaseString = $camelCaseWords -join " "

$date = [DateTime]::Now.ToString("yyyy-MM-dd")
$post = [System.IO.Path]::Combine($PSScriptRoot, "..\_posts")
$path = [System.IO.Path]::Combine($post, "$date-$BaseName.md")

if (-not $Force -and [System.IO.File]::Exists($path)) {
    Write-Host "File '$path' already exists."
    exit 1
}

$today = [datetime]::Now.ToString("yyyy-MM-dd HH:mm:ss zz00")

$contents = @"
---
title: $camelCaseString
author: [sionta]
# date: $today
# categories: [TOP_CATEGORIE, SUB_CATEGORIE]
# tags: [TAG] # must be lowercase
# img_path:
# image:
#   path:
#   alt:
#   lqip:
# pin: true
# toc: true
# math: false
# mermaid: false
# comments: true
# render_with_liquid: false
---

<!-- See https://chirpy.cotes.page/posts/write-a-new-post/ -->

## $camelCaseString

"@

$encoding = [System.Text.Encoding]::UTF8

[System.IO.File]::WriteAllText($path, $contents, $encoding)
