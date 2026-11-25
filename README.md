# Real-Time Vehicle Analytics Pipeline

A production-ready prototype and DeepStream architecture for the Elansol Computer Vision Intern assignment: RTSP video streaming, vehicle detection & ByteTrack tracking, HSV color classification, bidirectional line-crossing counting, database persistence, and a real-time React dashboard.

---

## Architecture Overview

```
                      +-----------------------------+
                      |   FFmpeg Video Streamer     |
                      |   (or live camera input)    |
                      +--------------+--------------+
                                     | RTSP (H.264)
                                     v
                      +-----------------------------+
                      |    MediaMTX RTSP Broker     |
                      |   rtsp://localhost:8554/    |
                      +--------------+--------------+
                                     |
                +--------------------+--------------------+
                |                                         |
                v                                         v
   +-------------------------+               +-------------------------+
   |  YOLO11 + ByteTrack     |               | NVIDIA DeepStream (Prod)|
   |  Vision Pipeline        |               | GStreamer + TensorRT    |
   +------------+------------+               +------------+------------+
                |                                         |
                +--------------------+--------------------+
                                     | Event Persistence
                                     v
                      +-----------------------------+
                      | SQLite / PostgreSQL Database|
                      |     (vehicle_events)        |
                      +--------------+--------------+
                                     |
                                     v
                      +-----------------------------+
                      |   FastAPI REST API Service  |
                      |   http://localhost:8000/    |
                      +--------------+--------------+
                                     | JSON Summary & Events
                                     v
                      +-----------------------------+
                      | React (Vite) Live Dashboard |
                      |   http://localhost:5173/    |
                      +-----------------------------+
```

---

## Quick Start (One-Click)

All dependencies and sample video are already installed and prepared:

- **Launch all services together**: Double-click `run_all.bat`
- **Or launch individually**:
  - `run_mediamtx.bat` &mdash; Starts the MediaMTX RTSP broker (`:8554`)
  - `run_backend.bat` &mdash; Starts the FastAPI backend (`http://localhost:8000`)
  - `run_frontend.bat` &mdash; Starts the React dashboard (`http://localhost:5173`)
  - `run_detector.bat` &mdash; Runs detection and line-crossing tracking on `sample_traffic.mp4`

---

## Manual Execution

### 1. Backend & Vision Detector
```powershell
cd backend
.\.venv\Scripts\activate
# Run detector on video (or RTSP stream: rtsp://localhost:8554/traffic)
python detector.py --source ..\sample_traffic.mp4 --line-y 320
# Run API server
uvicorn api:app --reload --host 0.0.0.0 --port 8000
```

### 2. Frontend Dashboard
```powershell
cd frontend
npm run dev
```
Open [http://localhost:5173](http://localhost:5173) in your browser.

### 3. RTSP Streaming (MediaMTX + FFmpeg)
```powershell
# 1. Start MediaMTX broker
.\mediamtx\mediamtx.exe mediamtx.yml

# 2. In another terminal, stream sample video over RTSP
.\scripts\stream_rtsp.bat

# 3. Connect detector to RTSP stream
python backend\detector.py --source rtsp://localhost:8554/traffic
```

---

## Docker Deployment (Full Stack)
```bash
docker compose up --build
```
Includes MediaMTX, PostgreSQL, DeepStream container, FastAPI backend, and React frontend.

---

## Assignment Specification Mapping

| Requirement | Implementation | Status |
| :--- | :--- | :--- |
| **Video Ingestion** | OpenCV / FFmpeg RTSP ingestion via MediaMTX | Ready & Tested |
| **Object Detection** | YOLO11n COCO classes (`car`, `truck`, `bus`, `motorcycle`) | Ready & Tested |
| **Object Tracking** | ByteTrack (`lapx` linear assignment) with persistent track IDs | Ready & Tested |
| **Color Classification** | HSV color heuristic on vehicle bounding-box crops | Ready & Tested |
| **Line-Crossing Counting** | Horizontal boundary line counting with directional tracking | Ready & Tested |
| **Database Persistence** | SQLAlchemy + SQLite (default) / PostgreSQL support | Ready & Tested |
| **Web Dashboard** | React + Vite dark mode UI with 3s auto-refresh | Ready & Tested |
| **DeepStream Config** | Pipeline configs (`config_infer_primary`, `nvdsanalytics`) | Included in `deepstream/` |
