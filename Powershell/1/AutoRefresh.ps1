# AutoRefresh.ps1
$date = Get-Date -format "yyyy-MM-dd"
$Path = "C:\Path\$date.txt" # Path of log file
$ServiceName = "" # Name of Windows service to be restarted

function Get-TimeStamp {
    return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)
}

function CheckStatus {
    Add-Content -Path $logpath "$(Get-TimeStamp) Checking status of $ServiceName"
    $status = (Get-Service $ServiceName).Status

    If ($status -eq 'Running' ) # Check if the service is running
    {
        Add-Content -Path $logpath "$(Get-TimeStamp) The service $ServiceName is $status"
    } 
    else {
        Add-Content -Path $logpath "$(Get-TimeStamp) The service $ServiceName is $status . Attempting to start."
        Try {
        Start-Service -Name $ServiceName -ErrorAction Stop
        } Catch {
            Add-Content -Path $logpath "$(Get-TimeStamp) Unable to start service"
            Add-Content -Path $logpath "$(Get-TimeStamp) See exception details here: $($_.exception.message) "
            Add-Content -Path $logpath "$(Get-TimeStamp) To aid in troubleshoting, the dependent services for $ServiceName (if any) are:"
            Get-Service -Name $ServiceName -RequiredServices | Out-File -FilePath $logpath -Append
        }
    }
}

$(CheckStatus) # Calling the function to initiate the check
