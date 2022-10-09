#AutoRefreshIISSite.ps1

$url = "" # IIS Site url to check status
$AppPool = "" # App Pool to be recycled
$ServerIP = "" # IP address of host
$path = "" # Path to log directory

# Get timestamp for logs
function Get-TimeStamp { 
  return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f(Get-Date)
}

# Get timestamp for JSON payload
function Get-TimeStamp-JSON { 
  return "{0:MM/dd/yy} {0:HH:mm:ss}" -f(Get-Date)
}

# Function to create log item
function Create-LogItem ($Text){ 
  Add-Content -Path $logpath "$(Get-TimeStamp) $Text"
}

# Function to get exceptions
function Get-Errors { 
  Create-LogItem ("Exception: $($_)")
  Create-LogItem ("Exception: $($_.exception)")
  Create-LogItem ("Exception: $($_.exception.message)")
}

# Log variables
$date = Get-Date -format "yyyy-MM-dd"
$logpath = "$path\$date.txt"

try{
  Import-Module WebAdministration -ErrorAction Stop
}
catch{
  $(Get-Errors)
}

# Send email notification
function SendEmailNotification ($Body){
$From = "" # Where email is to be sent from
$To = "" # Where email is to be sent
$Attachment = $logpath # Path to any file to be sent as an attachment
$Subject = "" # Subject of mail to be sent
$Body = "" # Body of mail to be sent
$SMTPServer = "" # SMTP server used to send out email
$SMTPPort = "" # Port of SMTP server
  Create-LogItem ("Sending mail to $To")
  try{
    Send-MailMessage -From $From -To $To -Subject $Subject -Body $Body -SmtpServer $SMTPServer -port $SMTPPort -Priority High -ErrorAction Stop -Attachments $Attachment
    Create-LogItem("Mail sent.")
  }
  catch{
    $(Get-Errors)
  }
}

# Refresh IIS App pool
function RecycleAppPool {
  Create-LogItem ("Attempting to refresh application pool")
  try {
    Restart-WebAppPool $AppPool -ErrorAction Stop
    Create-LogItem ("$AppPool was successfully restarted.")
    $Body = "The application pool on server $ServerIP was successfully restarted after receiving an invalid response code calling the home page. Find attached the log file for your review."
    SendEmailNotification ($Body)
    $TeamsMessage = "Successfully restarted Internet Banking UI after receiving an invalid response code."
    Send-TeamsNotification ($TeamsMessage)
  }
  catch {
    $(Get-Errors)
    $Body = "Unable to recycle app pool ($AppPool) on $ServerIP after an invalid response code was received trying to reach the application. Kindly login to the server and investigate. Also find the log file attached."
    SendEmailNotification ($Body)
    $TeamsMessage = "Unable to automatically refresh Internet Banking UI after receiving an invalid response code. Kindly login to the server to investigate."
    Send-TeamsNotification ($TeamsMessage)
  }
}

# Check status of IIS site
function CheckStatus {
  Create-LogItem ("Getting http status of $url")  
  try {
    $Response = Invoke-WebRequest -Uri $url -DisableKeepAlive -SkipCertificateCheck
    $StatusCode = $Response.StatusCode
    Create-LogItem ("$StatusCode The site is reachable.")
  } 
  catch {
    $(Get-Errors)
    $StatusCode =  $_.Exception.Response.StatusCode.value__
    Create-LogItem ("$StatusCode Invalid response code.")
    $(RecycleAppPool)
  }
}

$(CheckStatus)
