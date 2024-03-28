#!/bin/bash

WEBSITE="http://namecheap.com"

# find the load time from the last line removing Total Time and save it as string
TOTAL=$(curl -w "HTTP Version: %{http_version}\nCode: %{response_code}\nTotal Time: %{time_total} \n" --head $WEBSITE -L | tail -1 | sed 's/Total Time: //g')
echo "Here we are -$TOTAL-"

# set up the threshold
THRESHOLD=5.0

# Bash does not support float numbers by default, so we use | bc
# it should give -0 if it the Total time is higher than Threshold true and -1 if it is not 
result=$(echo "$TOTAL > $THRESHOLD" | bc ) 

# as we send an alert only when Total Time exceeds, we check if the result of the previous command is -0. If yes, we send an alert
if [ "$result" -eq 0 ];
then

    # SLACK can be configurate using this guide: https://api.slack.com/tutorials/tracks/posting-messages-with-curl
    # $ curl -X POST -H 'Content-type: application/json' --data '{"text": "Alert! The load time for $WEBSITE threshold is exceeded."}'  https://hooks.slack.com/services/YOUR/TOKENIZED/URL

	# I used the email service for sending an alert using SMTP
	 curl --url 'smtp://smtp.gmail.com:587' --ssl-reqd \ --mail-from 'rozalinmango@gmail.com' --mail-rcpt 'khrystyna.druzhynina@gmail.com' \ --upload-file emailbody.txt --user 'rozalinmango@gmail.com:cpki wdsa xtau ezvq'
fi