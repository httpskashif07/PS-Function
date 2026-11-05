<#
.SYNOPSIS
    Function that checks a product rating and shows a message.

.DESCRIPTION
    The Get-RatingMessage function takes the details of a product and its rating
    and creates a message showing the score and how the product is doing.
    If a comment is given it is shown on the next line.
    Product name can be sent using the pipeline.

.PARAMETER ProductName
    The name of the product (mandatory, can come from pipeline).

.PARAMETER Score
    Points the product got (mandatory, 1 to 10).

.PARAMETER MaxScore
    Highest points possible (5 to 10, default 10).

.PARAMETER RatingLabel
    Excellent, Average, Poor or Standard (default Standard).

.PARAMETER Comment
    Optional comment about the product.

.EXAMPLE
    Example usage:
    PS> Get-RatingMessage -ProductName Laptop -Score 8 -RatingLabel Excellent
    PS> "Printer","Router" | Get-RatingMessage -Score 4 -RatingLabel Poor

.NOTES
    Author: Kashif Sharma
    Created: 2026-11-04
    Version: 1.0
    Last Modified: 2026-11-04
    Change Log:
        1.0 - Initial release

.LINK
    https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters
#>

#Parameters

#Functions
function Get-RatingMessage {
    [CmdletBinding()]
    param (
        # product name is required and can be piped in
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [string]$ProductName,

        # score is required
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateRange(1, 10)]
        [int]$Score,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateRange(5, 10)]
        [int]$MaxScore = 10,

        [Parameter(ValueFromPipelineByPropertyName)]
        [ValidateSet("Excellent", "Average", "Poor", "Standard")]
        [string]$RatingLabel = "Standard",

        [Parameter(ValueFromPipelineByPropertyName)]
        [string]$Comment
    )

    process {
        # score should not be more than the max score
        if ($Score -gt $MaxScore) {
            Write-Warning "$ProductName : score $Score is more than max score $MaxScore"
            return
        }

        $msg = "Product $ProductName scored $Score points. This product is doing $RatingLabel."
        Write-Output $msg

        if ($Comment) {
            Write-Output "  Comment: $Comment"
        }
    }
}

#Execution Code
Write-Host "--- Single product ---"
Get-RatingMessage -ProductName Laptop -Score 8 -RatingLabel Excellent

Write-Host "--- Using pipeline ---"
"Laptop" | Get-RatingMessage -Score 8 -RatingLabel Excellent
"Printer", "Router" | Get-RatingMessage -Score 4 -RatingLabel Poor

Write-Host "--- Pipeline with objects ---" #$items= @() is used to create an array of objects.
$items = @(
    [PSCustomObject]@{ ProductName = "Webcam"; Score = 6; RatingLabel = "Average"}
    [PSCustomObject]@{ ProductName = "Charger"; Score = 7; MaxScore = 5 }
)
$items | Get-RatingMessage