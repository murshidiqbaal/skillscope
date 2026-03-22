"""
main.py
SkillScope AI — FastAPI application entry-point.

Run from the project root (parent of `backend/`):
    uvicorn backend.main:app --reload
"""

import sys
import os

# Allow both `uvicorn backend.main:app` (from root) and direct execution.
sys.path.insert(0, os.path.dirname(__file__))

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from core.config import settings
from routers.chat import router as chat_router
from routers.resume import router as resume_router
from routers.skills import router as skills_router

app = FastAPI(
    title=settings.APP_NAME,
    debug=settings.DEBUG,
    version="1.0.0",
    description="Career intelligence backend powering SkillScope AI Flutter app.",
)

# ── CORS ──────────────────────────────────────────────────────────────────────
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.ALLOWED_HOSTS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ── Routers ───────────────────────────────────────────────────────────────────
app.include_router(chat_router)
app.include_router(resume_router)
app.include_router(skills_router)


# ── Health / root ─────────────────────────────────────────────────────────────
@app.get("/", tags=["Meta"])
async def root() -> dict:
    """Root endpoint — confirms the server is running."""
    return {"message": "SkillScope AI Backend Running"}


@app.get("/health", tags=["Meta"])
async def health() -> dict:
    """Health-check endpoint used by load balancers and Docker HEALTHCHECK."""
    return {"status": "healthy"}
