@echo off
title MediaMTX RTSP Broker
cd /d "%~dp0"
echo Starting MediaMTX RTSP Broker on port 8554...
mediamtx\mediamtx.exe mediamtx.yml
pause
