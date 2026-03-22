"""
models/resume_models.py
Pydantic models for resume analysis, job roles, and learning resources.
"""

from typing import List, Optional
from pydantic import BaseModel


class LearningResource(BaseModel):
    """A single recommended learning resource."""

    title: str
    url: str
    description: Optional[str] = None
    platform: Optional[str] = None


class ResumeAnalysis(BaseModel):
    """Full analysis result returned after scanning a resume."""

    jobRole: str
    matchScore: int
    detectedSkills: List[str] = []
    missingSkills: List[str] = []
    recommendedResources: List[LearningResource] = []


class ResumeAnalysisResponse(BaseModel):
    """Top-level response envelope for POST /resume/validate."""

    analysis: ResumeAnalysis


class LearningResourcesRequest(BaseModel):
    """Request body for POST /learning-resources."""

    skills: List[str]


class JobRoleSkills(BaseModel):
    """Represents a job role with its required skill set."""

    roleId: str
    roleName: str
    requiredSkills: List[str] = []
    description: Optional[str] = None
    category: Optional[str] = None
