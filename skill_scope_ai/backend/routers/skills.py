"""
routers/skills.py
Skills catalog endpoint — paginated, optionally filtered by category.
"""

import sys
import os

sys.path.insert(0, os.path.dirname(os.path.dirname(__file__)))

from fastapi import APIRouter, HTTPException, Query
from models.skill_models import PaginatedSkillsResponse, SkillModel
from repositories.job_role_repository import job_role_repository

router = APIRouter(tags=["Skills"])


@router.get("/skills", response_model=PaginatedSkillsResponse, status_code=200)
async def get_skills(
    category: str | None = Query(default=None, description="Filter by skill category"),
    page: int = Query(default=0, ge=0, description="Zero-based page index"),
    page_size: int = Query(default=20, ge=1, le=100, description="Results per page"),
) -> PaginatedSkillsResponse:
    """
    Return a paginated list of skills from the Supabase `skills` table.

    Query parameters:
        category:  Optional string to filter by category.
        page:      Zero-based page number (default 0).
        page_size: Number of results per page (default 20, max 100).

    Returns:
        PaginatedSkillsResponse containing the skills slice and total count.

    Raises:
        HTTPException 500: Database or unexpected error.
    """
    try:
        rows, total = await job_role_repository.get_skills_paginated(
            category=category, page=page, page_size=page_size
        )
        skills = [
            SkillModel(
                id=str(row.get("id", "")),
                name=row.get("name", ""),
                description=row.get("description", ""),
                category=row.get("category", ""),
                demand_score=float(row.get("demand_score", 0.0)),
                growth_rate=row.get("growth_rate"),
                icon_url=row.get("icon_url"),
                tags=row.get("tags") or [],
                created_at=str(row["created_at"]) if row.get("created_at") else None,
            )
            for row in rows
        ]
        return PaginatedSkillsResponse(skills=skills, total=total)
    except Exception as exc:
        raise HTTPException(
            status_code=500, detail=f"Error fetching skills: {exc}"
        ) from exc
