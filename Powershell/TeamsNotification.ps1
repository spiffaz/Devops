# TeamsNotification.ps1

# Timestamp to be used for log file
function Get-TimeStamp {
  return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f(Get-Date)
}

# Timestamp to be used for Payload
function Get-TimeStamp-JSON {
  return "{0:MM/dd/yy} {0:HH:mm:ss}" -f(Get-Date)
}

$date = Get-Date -format "yyyy-MM-dd" # Get date format to name log file
$logpath = "F:\Logs\\$date.txt" # Location where logs are to be stored is to be defined here. Change this.

function Send-TeamsNotification ($TeamsMessage){
  $ImportantMessageTitle = "" # Message Title
  $VariableForRandomHeading = "" # Sample text
  # New sections can be added under Sections
  $TeamMessageBody = 
@"
{
  "@type": "MessageCard",
  "@context": "http://schema.org/extensions",
  "summary": "$ImportantMessageTitle",
  "text": "Random text", # Another Sample text
  "sections": [{
    "activityTitle": "$ImportantMessageTitle",
    "facts": [
      {
        "name": "Timestamp",
        "value": "$(Get-TimeStamp-JSON)" # Calling the Get-TimeStamp-JSON function
      },
      {
        "name": "Some random heading",
        "value": "$VariableForRandomHeading"
      },
      {
        "name": "Message",
        "value": "$TeamsMessage"
      },
      {
        "name": "Some random path",
        "value": "F:\\Logs"
      }
    ]
  }]
}
"@
  $parameters = @{
  "URI" = '' #Teams Incoming Webhook url
  "Method" = 'POST'
  "Body" = $TeamMessageBody
  "ContentType" = 'application/json'
  }
	
  try {
    $response = Invoke-RestMethod @parameters 
    if ( 1 -eq $response ) { # Check if the Teams notification was sent
      Add-Content -Path $logpath "$(Get-TimeStamp) Teams notification sent." # Log successful notification
    }
  }
  catch {
    Add-Content -Path $logpath "$(Get-TimeStamp) $($_)"
    Add-Content -Path $logpath "$(Get-TimeStamp) $($_.exception)"
    Add-Content -Path $logpath "$(Get-TimeStamp) $($_.exception.message)"
  }
}

$TeamsMessage = "" # Message to be sent
Send-TeamsNotification ($TeamsMessage) # Call the function
