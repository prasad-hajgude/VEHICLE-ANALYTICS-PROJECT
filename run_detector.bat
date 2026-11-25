@echo off
title Vehicle Analytics - Vision Detector
cd /d "%~dp0"
echo Starting Vehicle Detector and Tracker on sample_traffic.mp4 ...
backend\.venv\Scripts\python.exe backend\detector.py --source sample_traffic.mp4 --line-y 320
pause
