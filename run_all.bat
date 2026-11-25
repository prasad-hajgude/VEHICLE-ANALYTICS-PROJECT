@echo off
title Vehicle Analytics System Launcher
cd /d "%~dp0"

echo ================================================================
echo    Launching Real-Time Vehicle Analytics System
echo ================================================================

echo [1/4] Starting MediaMTX RTSP Broker...
start "MediaMTX Broker" cmd /c "run_mediamtx.bat"

timeout /t 2 /nobreak >nul

echo [2/4] Starting FastAPI Backend...
start "FastAPI Backend" cmd /c "run_backend.bat"

timeout /t 2 /nobreak >nul

echo [3/4] Starting React Dashboard...
start "React Dashboard" cmd /c "run_frontend.bat"

timeout /t 3 /nobreak >nul

echo [4/4] Starting Detector & Tracker...
start "Vehicle Detector" cmd /c "run_detector.bat"

echo ================================================================
echo All services launched!
echo - React Dashboard: http://localhost:5173
echo - FastAPI Docs:    http://localhost:8000/docs
echo - RTSP Stream:     rtsp://localhost:8554/traffic
echo ================================================================
