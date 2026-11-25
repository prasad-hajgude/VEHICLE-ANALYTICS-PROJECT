@echo off
title Vehicle Analytics - FastAPI Backend
cd /d "%~dp0backend"
echo Starting FastAPI Backend at http://localhost:8000 ...
call .venv\Scripts\activate.bat
uvicorn api:app --reload --host 0.0.0.0 --port 8000
pause
