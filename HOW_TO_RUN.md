# Complete Step-by-Step Guide: How to Run the Vehicle Analytics Pipeline

This document details every exact command used to run each component of the pipeline, with options for **PowerShell**, **Command Prompt (CMD)**, and **VS Code Terminals**.

---

## Architecture at a Glance

```
 [sample_traffic.mp4] ---> [MediaMTX Broker] ---> [detector.py (YOLO11 + ByteTrack)]
                                                            |
                                                            v
 [React UI (Vite :5173)] <--- [FastAPI Backend (:8000)] <--- [SQLite (vehicle_events.db)]
```

---

## Method 1: The One-Click Way (Fastest)

Double-click the master launcher in File Explorer, or run this single command:

### PowerShell / Command Prompt:
```cmd
.\run_all.bat
```

> **What this does:**
> Launches 4 separate windows automatically:
> 1. MediaMTX RTSP Broker (`:8554`)
> 2. FastAPI Backend (`http://localhost:8000`)
> 3. React Vite Dashboard (`http://localhost:5173`)
> 4. Vehicle Detector with live OpenCV window

---

## Method 2: Running via VS Code Terminals (Step-by-Step)

In Visual Studio Code, press **`Ctrl + ~`** (or go to **Terminal > New Terminal**).

Open **3 separate terminal tabs** by clicking the **`+`** icon on the top-right of the terminal pane.

---

### Terminal 1: Start the Backend API Server

This server queries the database and serves the data to the React dashboard.

#### PowerShell:
```powershell
cd "C:\Users\PRASAD\OneDrive\Desktop\vehicle analytics project\backend"
.\.venv\Scripts\activate
uvicorn api:app --reload --host 0.0.0.0 --port 8000
```

#### Command Prompt (CMD):
```cmd
cd "C:\Users\PRASAD\OneDrive\Desktop\vehicle analytics project\backend"
call .venv\Scripts\activate.bat
uvicorn api:app --reload --host 0.0.0.0 --port 8000
```

#### One-Liner from Project Root (No `cd` needed):
```powershell
backend\.venv\Scripts\python.exe -m uvicorn backend.api:app --reload --host 0.0.0.0 --port 8000
```

- **Verify it's working:**
  - Interactive API Docs: [http://localhost:8000/docs](http://localhost:8000/docs)
  - Raw JSON Summary: [http://localhost:8000/api/summary](http://localhost:8000/api/summary)
  - Events List: [http://localhost:8000/api/events](http://localhost:8000/api/events)
- **To Stop:** Press **`Ctrl + C`** in the terminal.

---

### Terminal 2: Start the React Frontend Dashboard

This starts the Vite web development server for the visual UI.

#### In Terminal 2 (Click `+` icon in VS Code):
```powershell
cd "C:\Users\PRASAD\OneDrive\Desktop\vehicle analytics project\frontend"
npm run dev
```

#### One-Liner from Project Root:
```powershell
npm --prefix frontend run dev
```

- **Verify it's working:**
  - Open your browser to: **[http://localhost:5173](http://localhost:5173)**
  - You will see the "Vehicle Analytics" dashboard. It polls the backend every 3 seconds.
- **To Stop:** Press **`Ctrl + C`** in the terminal.

---

### Terminal 3: Run the Vehicle Detector & Tracker

This runs YOLO11 detection, ByteTrack tracking, HSV color classification, and counts vehicles crossing the line, saving events to the database.

#### In Terminal 3 (Click `+` icon in VS Code):
```powershell
cd "C:\Users\PRASAD\OneDrive\Desktop\vehicle analytics project\backend"
.\.venv\Scripts\activate
python detector.py --source ..\sample_traffic.mp4 --line-y 320
```

#### One-Liner from Project Root:
```powershell
backend\.venv\Scripts\python.exe backend\detector.py --source sample_traffic.mp4 --line-y 320
```

- **What you will see:**
  - An OpenCV GUI window titled **"Vehicle Analytics"**.
  - **Green boxes**: Detected vehicles with their assigned tracker ID, vehicle type (`car`, `truck`, `bus`), and estimated color (`blue`, `gray`, `red`, etc.).
  - **Yellow line**: The virtual counting boundary at `y = 320`.
  - **Top-left counter**: Increments as vehicles cross the boundary.
- **Look at your browser:** Check [http://localhost:5173](http://localhost:5173) &mdash; the dashboard cards and table will update live!
- **To Stop:** Click on the OpenCV video window and press the letter **`q`** on your keyboard (or press `Ctrl + C` in the terminal).

---

## Method 3: Real-Time RTSP Stream Ingestion (MediaMTX + FFmpeg)

To demonstrate the full RTSP broker pipeline (Phase 1 specification):

### Step 1: Start MediaMTX RTSP Broker
In Terminal 1:
```powershell
.\mediamtx\mediamtx.exe mediamtx.yml
```
> MediaMTX will listen on `rtsp://localhost:8554`.

### Step 2: Stream Video via FFmpeg to MediaMTX
In Terminal 2:
```powershell
.\scripts\stream_rtsp.bat
```
Or with raw FFmpeg:
```powershell
ffmpeg -re -stream_loop -1 -i sample_traffic.mp4 -c:v libx264 -preset ultrafast -tune zerolatency -pix_fmt yuv420p -b:v 2000k -f rtsp -rtsp_transport tcp rtsp://localhost:8554/traffic
```

### Step 3: Run Detector against the RTSP Stream
In Terminal 3:
```powershell
backend\.venv\Scripts\python.exe backend\detector.py --source rtsp://localhost:8554/traffic --line-y 320
```

---

## Command Reference & Optional Flags

### 1. `detector.py` Commands

| Command | Purpose |
| :--- | :--- |
| `python detector.py --source ..\sample_traffic.mp4 --line-y 320` | Standard video file detection with line at y=320 |
| `python detector.py --source 0` | Use live computer **webcam** (default camera) |
| `python detector.py --source rtsp://localhost:8554/traffic` | Stream input from MediaMTX RTSP broker |
| `python detector.py --source ..\sample_traffic.mp4 --no-display` | **Headless mode** (no GUI window, maximum FPS) |
| `python detector.py --source ..\sample_traffic.mp4 --line-y 260` | Change counting line vertical position to 260px |
| `python detector.py --source ..\sample_traffic.mp4 --model yolo11s.pt` | Use larger model (small) instead of nano |

### 2. Backend (`uvicorn`) Commands

| Command | Purpose |
| :--- | :--- |
| `uvicorn api:app --reload --port 8000` | Start API server on localhost:8000 with auto-reload |
| `uvicorn api:app --host 0.0.0.0 --port 8000` | Expose API server across local network |

### 3. Frontend (`npm`) Commands

| Command | Purpose |
| :--- | :--- |
| `npm run dev` | Start Vite development server at `http://localhost:5173` |
| `npm run build` | Build optimized production bundle in `frontend/dist/` |

---

## Shortcut Batch Files Summary

Run any of these directly from your project folder:

- **`run_all.bat`**: Launches Broker + Backend + Frontend + Detector together.
- **`run_backend.bat`**: Runs FastAPI server in its own window.
- **`run_frontend.bat`**: Runs React/Vite dashboard in its own window.
- **`run_detector.bat`**: Runs the vision tracker on `sample_traffic.mp4`.
- **`run_mediamtx.bat`**: Runs the MediaMTX broker.
- **`scripts\stream_rtsp.bat`**: Publishes RTSP stream using FFmpeg.

---

## How to Reset Data

If you want to start counting from zero:
1. Stop the detector and backend (`Ctrl + C` or `q`).
2. Delete the database file:
   ```powershell
   Remove-Item backend\vehicle_events.db
   ```
3. Restart the backend and detector. The database will automatically be recreated fresh with 0 crossings.
