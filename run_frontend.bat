@echo off
title Vehicle Analytics - React Dashboard
cd /d "%~dp0frontend"
echo Starting React Vite Dashboard at http://localhost:5173 ...
call npm run dev
pause
