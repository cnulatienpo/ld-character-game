from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .routes import api as api_router
from . import telemetry

app = FastAPI(title="LD Character Game - Python Scaffold")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(api_router.router, prefix="/api")


@app.post("/api/telemetry")
async def post_telemetry(event: telemetry.TelemetryEvent):
    telemetry.save(event)
    return {"ok": True}


@app.get("/healthz")
async def healthz():
    return {"ok": True}


@app.get("/version")
async def version():
    return {"ok": True, "version": "0.0.0-scaffold"}
