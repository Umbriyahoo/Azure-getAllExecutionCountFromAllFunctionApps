#Get the execution count of all FA in RG

connect-azaccount

$subscriptionList = Get-AzSubscription -ErrorAction silentlyContinue
$select = $subscriptionList | Select SubscriptionId, Name, State, TenantId | Out-GridView -OutputMode Multiple -Title "Please select a subscription"

$subscriptionId = $select.SubscriptionId


# Set the subscription context
Set-AzContext -SubscriptionId $subscriptionId

# Provide the resource group and Function App name
$resourceGroupName = "Your RG name"

# Get all Function Apps in the resource group
$functionApps = Get-AzFunctionApp -ResourceGroupName $resourceGroupName



# Iterate through each Function App and print its status
foreach ($functionApp in $functionApps) {
    Write-Host "Function App Name: $($functionApp.Name)"
    $metric = Get-AzMetric -ResourceId "/subscriptions/$subscriptionId/resourceGroups/$resourceGroupName/providers/Microsoft.Web/sites/$functionAppName" -MetricName "FunctionExecutionCount" -StartTime $startTime -EndTime $endTime -TimeGrain 01:00:00 -Aggregation Total
    $executionCount = $metric.Data | Measure-Object -Property Total -Sum | Select-Object -ExpandProperty Sum
    Write-Host "Function App Execution Count (Last 24 hours): $executionCount"
}
