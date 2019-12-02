$text = 'testhkir@gmail.com:H1pqxsdo6RuK6HPd7Bek63BC'
$bytes = [System.Text.Encoding]::UTF8.GetBytes($text)
$EncodedText = [Convert]::ToBase64String($Bytes)
$EncodedText
$basic = "Basic "+$EncodedText
$global:header = @{
    'Authorization' = $basic
}


$Global:JiraUrl = "https://testhkir.atlassian.net/rest/api/2"

##############
# Functions
##############
function GetJiraIssue {
    param (
        [string] $issueId
    )
    $uri = $Global:JiraUrl + "/issue/$issueId"
    $res = Invoke-RestMethod -uri $uri -Method Get -Headers $global:header -ContentType "application/json"
    return $res         
}

function GetJiraIssues {
    $uri = $Global:JiraUrl + "/search?jql=project=FDM AND issuetype=TASK" 
    $res = Invoke-RestMethod -uri $uri -Method Get -Headers $global:header -ContentType "application/json"
    return $res.issues        
}

function GetIssueTypes {
    $uri = $Global:JiraUrl + "/issuetype" 
    $res = Invoke-RestMethod -uri $uri -Method Get -Headers $global:header -ContentType "application/json"
    return $res         
    
}

##############
# Start
##############

$issue = GetJiraIssue -issueId "10006"

$issues = GetJiraIssues
foreach($i in $issues){
    Write-Host $i.id $i.key $i.fields.summary $i.fields.issuetype.name
}

$issueTypes = GetIssueTypes