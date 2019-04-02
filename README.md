# watchcat
Script to check status of network service with netcat

Started writing this script as my docker server (Udoo x86 Ultra serving Docker containers) does not expose the ports anymore of the FritzBox! restarts/reconnects (probably due to new ipv6 delegation). 

This script checks the external IP of my services and reboots the service if host is not reachable (timeouts * interval in seconds). 

Run with cron every minute, as script checks if it is already running.
