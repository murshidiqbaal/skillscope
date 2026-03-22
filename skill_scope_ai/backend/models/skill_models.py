"""
models/skill_models.py
Pydantic models for the skills catalog and paginated response.
"""

from typing import List, Optional
from pydantic import BaseModel


class SkillModel(BaseModel):
    """Represents a single skill entry from the Supabase `skills` table."""

    id: str
    name: str
    description: str
    category: str
    demand_score: float
    growth_rate: Optional[float] = None
    icon_url: Optional[str] = None
    tags: List[str] = []
    created_at: Optional[str] = None


class PaginatedSkillsResponse(BaseModel):
    """Paginated response envelope for GET /skills."""

    skills: List[SkillModel]
    total: int
