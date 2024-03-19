#Requires -Version 6

param (
    [Parameter(Mandatory = $true)]
    [Alias('n', 'bn', 'name')]
    [string]$BaseName,

    [Alias('f')]
    [switch]$Force
)

$nowDate = Get-Date -Format 'yyyy-MM-dd'

$postDirs = @(
    "$PSScriptRoot\"
    "$PSScriptRoot\..",
    "$PSScriptRoot\..\.."
)

$dirFound = $false
foreach ($postDir in $postDirs) {
    if (Test-Path "$postDir\_posts") {
        $resolvedDir = Resolve-Path "$postDir\_posts"
        $postFile = Join-Path $resolvedDir "$nowDate-$BaseName.md"
        $dirFound = $true
        break
    }
}

if (-not $dirFound) {
    Write-Host "Directory '_posts' not found.`n$postDirs"
    exit 1
}

if (-not $Force -and (Test-Path $postFile)) {
    Write-Host "File '$postFile' already exists."
    exit 1
}

function ConvertTo-TitleCase {
    param([string]$inputString)
    $words = $inputString -replace '[/\-\\_]', '\s+' -split '\s+'
    $sencase = foreach ($word in $words) {
        $word.Substring(0, 1).ToUpper() + $word.Substring(1).ToLower()
    }
    $sencase = $sencase -join ' '
    return $sencase
}

function Get-RandomHexColor {
    $randomValue = Get-Random -Minimum 0x00ff00 -Maximum (0xff0000 + 1)
    $randomColor = '#' + '{0:X6}' -f $randomValue
    return $randomColor
}

$titleName = ConvertTo-TitleCase $BaseName
# $char = Get-Random -InputObject ('#', '●', '▶') -Count 1
# $tagName = "<span style=`"color:$(Get-RandomHexColor)`">$char</span>"
$formatDate = Get-Date -Format 'yyyy-MM-dd HH:mm:ss zz00'

$contents = @"
---
title: $titleName
author: sionta
date: $formatDate
categories: [TOP, SUBS]
tags: [TAGS]
toc: true
# pin: true
# img_path:
# image:
#   path:
#   lqip:
#   alt:
comments: true
---

<!-- See https://chirpy.cotes.page/posts/write-a-new-post/ -->

## $titleName

"@

Write-Host "Output file: $postFile"
Out-File -FilePath $postFile -Encoding utf8NoBOM -InputObject $contents
