read -p "Input port you want to check: " port 
ip=$(dig +short orientsoftware.com)
status=$(nc -zvw10 $ip $port)
