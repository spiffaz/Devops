#EmailNotification.ps1

$date = Get-Date -format "yyyy-MM-dd"
$path = "\$date.txt" # Path to log file. Put in the entire path
$url = "" 
$AppPool = "" # Application pool to be recycled

#Email variables
$From = "" # Where email is to be sent from
$To = "" # Where email is to be sent
$Attachment = $logpath # Path to any file to be sent as an attachment
$Subject = "" # Subject of mail to be sent
$Body = "" # Body of mail to be sent
$SMTPServer = "" # SMTP server used to send out email
$SMTPPort = "" # Port of SMTP server

function Get-TimeStamp {
    return "[{0:MM/dd/yy}{0:HH:mm:ss}]" -f(Get-Date)
}

function SendEmailNotification {
    Add-Content -Path $logpath "$(Get-TimeStamp) Sending mail to $To"
    try{ # Send mail
        Send-MailMessage -From $From -To $To -Subject $Subject -Body $Body -SmtpServer $SMTPServer -port $SMTPPort -Priority High -ErrorAction Stop -Attachments $Attachment
        Add-Content -Path $logpath "$(Get-TimeStamp) Mail sent." 
    }
    catch{
        Add-Content -Path $logpath "$(Get-TimeStamp) Send failure. Reason: $($_.exception.message) "
    }
}

$(SendEmailNotification)
