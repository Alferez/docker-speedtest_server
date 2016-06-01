#!/bin/bash

echo "Starting Speedtest Daemon...."
cd /speedtest/
/speedtest/ooklaserver.sh install -f

echo "Starting Apache...."
service apache2 start

while true
do
	sleep 1
done

