@echo off
title Remove RustDesk Firewall Port 21118

echo Removing Windows Firewall rules for TCP port 21118...

netsh advfirewall firewall delete rule name="RustDesk TCP 21118 In"
netsh advfirewall firewall delete rule name="RustDesk TCP 21118 Out"

echo.
echo Done!
pause