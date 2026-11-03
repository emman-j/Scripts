@echo off
title Add RustDesk Firewall Port 21118

echo Adding Windows Firewall rules for TCP port 21118...

netsh advfirewall firewall add rule name="RustDesk TCP 21118 In" dir=in action=allow protocol=TCP localport=21118
netsh advfirewall firewall add rule name="RustDesk TCP 21118 Out" dir=out action=allow protocol=TCP localport=21118

echo.
echo Done!
pause