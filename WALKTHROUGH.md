# Walkthrough script (about 3–5 minutes)

**Introduction:** Hi, my name is Prasad. This project is a prototype real-time vehicle analytics pipeline. It detects and tracks vehicles, estimates their color, counts line crossings, stores events, and displays analytics.

**Architecture:** The video source is read through OpenCV. YOLO detects vehicles and ByteTrack assigns IDs. When a tracked vehicle crosses a virtual horizontal line, the event is stored in the database. FastAPI exposes summary and event endpoints, and the React dashboard displays the data.

**Code:** Show `detector.py`: class filtering, tracker IDs, crop-based color heuristic, line crossing, and persistence. Explain that color estimation is a lightweight heuristic rather than a trained classifier.

**Database/API:** Show stored event fields and the `/api/events` and `/api/summary` endpoints.

**Dashboard:** Show the total crossings, color/type breakdown, and recent events.

**Honest limitation:** This demo uses Ultralytics tracking and OpenCV as a prototype alternative. The assignment specifically requests DeepStream and MediaMTX; discuss how the prototype can be adapted to a DeepStream/GStreamer pipeline and RTSP input. Do not represent the prototype as DeepStream if it is not.
