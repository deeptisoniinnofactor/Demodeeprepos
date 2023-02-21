function Get-AccessToken {
    $url = "https://login.microsoftonline.com/f9585ec8-4ace-4f52-b3e8-bbc374858458/oauth2/v2.0/token"

    $clientId = '8d6d5af0-cff9-424b-9a25-70b4c166070b'
    $clientSecret = 'QvY8Q~cGzjAJzQ1-TRDesEzKHt8NXhrPmFcDFb~m'

    $body = "client_id=$clientId&client_secret=$clientSecret&scope=https://management.azure.com/.default&grant_type=client_credentials"

    # $response = Invoke-WebRequest -Method Post -Headers $headers -Uri $url -Body $payloadJson
    $response = Invoke-WebRequest -Method Post -Uri $url -Body $body -ContentType 'application/x-www-form-urlencoded' -UseBasicParsing

    $responseBody = $response.Content | ConvertFrom-Json

    return $responseBody.access_token
}

function Get-MatchingVmIds {
    param(
        [string] $vmName = '',
        [string] $vmIpAddress = ''
    )

    $accessToken = Get-AccessToken

    $url = 'https://management.azure.com/providers/Microsoft.ResourceGraph/resources?api-version=2020-04-01-preview'
    $headers = @{
        'Authorization' = "Bearer $accessToken"
    }

    $query = "Resources | where type == 'microsoft.compute/virtualmachines'"
    if ($vmName -ne '') {
        $query += " and name == '$vmName'"
    }
    if ($vmIpAddress -ne '') {
        # $query += " and "
        # TODO
    }

    $payload = @{
        query = $query
    }
    $payloadJson = $payload | ConvertTo-Json

    $response = Invoke-WebRequest -Method Post -Headers $headers -Uri $url -Body $payloadJson -ContentType 'application/json' -UseBasicParsing

    $responseBody = $response.Content | ConvertFrom-Json

    $vmIds = [System.Collections.ArrayList]@()
    foreach ($row in $responseBody.data.rows) {
        [void]$vmIds.Add($row[0])
    }

    return $vmIds
}

function Restart-AzVmServices {

}