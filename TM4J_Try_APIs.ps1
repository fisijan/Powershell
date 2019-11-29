###################
# Constants
###################

$global:url = "https://api.adaptavist.io/tm4j/v2"
$global:header = @{
    'Authorization' = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjb250ZXh0Ijp7InV1aWQiOiJLcVNVOVlpNHMiLCJhcGlHd0tleSI6IldDWkYwTExLTExldUFlVURTVDZROFFpTVg3MUpVTWsxUlJqaUtqSTgiLCJiYXNlVXJsIjoiaHR0cHM6Ly90ZXN0aGtpci5hdGxhc3NpYW4ubmV0IiwidXNlciI6eyJhY2NvdW50SWQiOiI1ZGRiODY5MDRhZTdiODBkMGQxOTQ0MmQifX0sImlhdCI6MTU3NTAyNjUzOCwiZXhwIjoxNjA2NTg0MTM4LCJpc3MiOiJjb20ua2Fub2FoLnRlc3QtbWFuYWdlciIsInN1YiI6ImFkYzgyYjY5LTMwMzMtM2U0Zi05NzI4LTljNWYwZGQwZGVjYiJ9.lLskv4NV_PphRoDbkNj-KoLYWlpGSLIex7RUpJli7c0'
}
$global:contenttype = 'application/json; charset=ISO-8859-1'


###################
# Functions
###################

function GetTCases {
    $uri = $global:url+"/testcases"
    $res = Invoke-RestMethod -Uri $uri -Method Get -Headers $global:header -ContentType $global:contenttype
    return $res.values
}

function GetTCase {
    param (
        [string] $TCaseKey
    )
    $uri = $global:url+"/testcases/$TCaseKey"
    $res = Invoke-RestMethod -Uri $uri -Method Get -Headers $global:header -ContentType $global:contenttype
    return $res
}

function GetTCycles {
    $uri = $global:url+"/testcycles"
    $res = Invoke-RestMethod -Uri $uri -Method Get -Headers $global:header -ContentType $global:contenttype
    return $res.values
}

function GetTCaseLinks{
    param ([String] $key )
    $uri = $global:url+"/testcases/$key/links"
    $res = Invoke-RestMethod -Uri $uri -Method Get -Headers $global:header -ContentType $global:contenttype
    return $res.issues

}

function GetIssue {
    param (
        [String] $uri
    )
    $res = Invoke-RestMethod -Uri $uri -Method Get -Headers $global:header -ContentType $global:contenttype
    return $res.issues
}

function GetTPlans {
    $uri = $global:url+"/testplans"
    $res = Invoke-RestMethod -Uri $uri -Method Get -Headers $global:header -ContentType $global:contenttype
    return $res.values
}

function GetTProjects {
    $uri = $global:url+"/projects"
    $res = Invoke-RestMethod -Uri $uri -Method Get -Headers $global:header -ContentType $global:contenttype
    return $res.values
}

function CreateTCase {
    $uri = $global:url+"/testcases"
    $req = @{ 'projectKey'='EGYJ'
     'name'='API create TC'
    }
    $json = ConvertTo-Json $req
    $res=Invoke-RestMethod -Uri $uri -Method Post -Headers $global:header -ContentType $global:contenttype -Body $json
    return $res.key
}

function CreateIssueLink {
    param (
        [string] $TCaseKey,
        [int] $IssueID
    )
    $uri = $global:url+"/testcases/$TCaseKey/links/issues"
    $req = @{ 'issueId'=$IssueID
     'type'='COVERAGE'
    }
    $json = ConvertTo-Json $req
    Invoke-RestMethod -Uri $uri -Method Post -Headers $global:header -ContentType $global:contenttype -Body $json
}

function GetTestExecutions {
    $uri = $global:url+"/testexecutions"
    $res = Invoke-RestMethod -Uri $uri -Method Get -Headers $global:header -ContentType $global:contenttype
    return $res.values
}


##################
# Start
##################

<#
Write-Host "TestCases: "

$testcases = GetTCases

foreach ( $tc in $testcases ) {
    Write-Host "  $($tc.name)"
    $issues = GetTCaseLinks -key $tc.key
    Write-Host "  Issues:"
    foreach ($i in $issues ){
        Write-Host "     " $i.issueID
    }
}
$testcycles = GetTCycles

Write-Host "TestCycles: "

foreach ( $tcy in $testcycles ) {
    Write-Host "  " $tcy.name
}


$projects = GetTProjects

Write-Host "TestProjects: "

foreach ( $p in $projects ) {
    Write-Host "  " $tcy.name
}

$TCaseKey = CreateTCase
CreateIssueLink -TCaseKey $TCaseKey -IssueId 10006
#>

#$tc = GetTCase -TCaseKey "FDM-T2"

$testexecutions = GetTestExecutions