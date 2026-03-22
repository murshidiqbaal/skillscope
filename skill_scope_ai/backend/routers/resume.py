"""
routers/resume.py
Resume validation, job roles, and learning resources endpoints.
"""

import sys
import os

sys.path.insert(0, os.path.dirname(os.path.dirname(__file__)))

import io
from fastapi import APIRouter, File, Form, HTTPException, UploadFile
from pypdf import PdfReader
from models.resume_models import (
    JobRoleSkills,
    LearningResource,
    LearningResourcesRequest,
    ResumeAnalysis,
    ResumeAnalysisResponse,
)
from services.nlp_engine import nlp_engine
from repositories.job_role_repository import job_role_repository

router = APIRouter(tags=["Resume"])

_MAX_PDF_BYTES = 10 * 1024 * 1024  # 10 MB


@router.post("/resume/validate", response_model=ResumeAnalysisResponse, status_code=200)
async def validate_resume(
    job_role: str = Form(...),
    resume: UploadFile = File(...),
) -> ResumeAnalysisResponse:
    """
    Upload a PDF resume and analyse it against a target job role using the local AI model.

    Args:
        job_role: The desired job role (multipart form field).
        resume:   The uploaded PDF file (multipart form file).

    Returns:
        ResumeAnalysisResponse containing the full analysis.

    Raises:
        HTTPException 400: Non-PDF file or unreadable PDF.
        HTTPException 413: File exceeds 10 MB limit.
        HTTPException 500: Unexpected processing error.
    """
    # --- Validation: file type ---
    filename = resume.filename or ""
    if not filename.lower().endswith(".pdf"):
        raise HTTPException(status_code=400, detail="Only PDF files are supported.")

    # --- Validation: file size ---
    content = await resume.read()
    if len(content) > _MAX_PDF_BYTES:
        raise HTTPException(
            status_code=413,
            detail="Resume file is too large. Max 10MB allowed.",
        )

    # --- Extract text from PDF ---
    try:
        pdf_reader = PdfReader(io.BytesIO(content))
        pages_text = [page.extract_text() or "" for page in pdf_reader.pages]
        full_text = "\n".join(pages_text).strip()
    except Exception as exc:
        raise HTTPException(
            status_code=400, detail=f"Could not extract text from the PDF: {exc}"
        ) from exc

    if not full_text:
        raise HTTPException(
            status_code=400, detail="Could not extract text from the PDF."
        )

    # --- AI analysis ---
    try:
        result = await nlp_engine.analyze_resume(full_text, job_role)
    except Exception as exc:
        raise HTTPException(
            status_code=500, detail=f"Error processing resume: {exc}"
        ) from exc

    # Ensure jobRole is present in the result dict.
    result.setdefault("jobRole", job_role)

    # Normalise recommendedResources to LearningResource objects.
    raw_resources = result.get("recommendedResources", [])
    resources = []
    for item in raw_resources:
        if isinstance(item, dict):
            resources.append(
                LearningResource(
                    title=item.get("title", ""),
                    url=item.get("url", ""),
                    description=item.get("description"),
                    platform=item.get("platform"),
                )
            )

    analysis = ResumeAnalysis(
        jobRole=result.get("jobRole", job_role),
        matchScore=int(result.get("matchScore", 0)),
        detectedSkills=result.get("detectedSkills", []),
        missingSkills=result.get("missingSkills", []),
        recommendedResources=resources,
    )

    return ResumeAnalysisResponse(analysis=analysis)


@router.get("/job-roles", response_model=list[JobRoleSkills], status_code=200)
async def get_job_roles() -> list[JobRoleSkills]:
    """
    Return all available job roles with their required skill sets.

    Returns:
        List of JobRoleSkills objects fetched from Supabase.

    Raises:
        HTTPException 500: Database or unexpected error.
    """
    try:
        rows = await job_role_repository.get_all_job_roles()
        result = []
        for row in rows:
            result.append(
                JobRoleSkills(
                    roleId=str(row.get("id", "")),
                    roleName=row.get("role_name", ""),
                    requiredSkills=row.get("required_skills") or [],
                    description=row.get("description"),
                    category=row.get("category"),
                )
            )
        return result
    except Exception as exc:
        raise HTTPException(
            status_code=500, detail=f"Error fetching job roles: {exc}"
        ) from exc


@router.post(
    "/learning-resources",
    response_model=list[LearningResource],
    status_code=200,
)
async def get_learning_resources(
    request: LearningResourcesRequest,
) -> list[LearningResource]:
    """
    Return learning resources matching any of the provided skill names.

    Args:
        request: JSON body with a `skills` list.

    Returns:
        List of LearningResource objects.

    Raises:
        HTTPException 400: Empty skills list.
        HTTPException 500: Database or unexpected error.
    """
    if not request.skills:
        raise HTTPException(status_code=400, detail="Skills list must not be empty.")

    try:
        rows = await job_role_repository.get_resources_for_skills(request.skills)
        return [
            LearningResource(
                title=row.get("title", ""),
                url=row.get("url", ""),
                description=row.get("description"),
                platform=row.get("platform"),
            )
            for row in rows
        ]
    except Exception as exc:
        raise HTTPException(
            status_code=500, detail=f"Error fetching learning resources: {exc}"
        ) from exc
