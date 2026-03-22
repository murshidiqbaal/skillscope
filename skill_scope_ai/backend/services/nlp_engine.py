"""
services/nlp_engine.py
Resume analysis service powered by the local Ollama model via the `ollama` pip package.
"""

import sys
import os

sys.path.insert(0, os.path.dirname(os.path.dirname(__file__)))

import json
import re
import ollama
from core.config import settings


_ANALYSIS_PROMPT_TEMPLATE = """
You are an expert career coach and resume analyst.

Analyse the following resume against the target job role "{job_role}".

Return ONLY a valid JSON object (no markdown, no explanation) with this exact structure:
{{
  "matchScore": <integer 0-100>,
  "detectedSkills": ["skill1", "skill2", ...],
  "missingSkills": ["skill1", "skill2", ...],
  "recommendedResources": [
    {{
      "title": "Resource title",
      "url": "https://example.com",
      "description": "Short description of what this teaches",
      "platform": "Platform name (e.g. Coursera, YouTube, Udemy)"
    }}
  ]
}}

Resume text:
\"\"\"
{resume_text}
\"\"\"

Target job role: {job_role}

Rules:
- matchScore must be an integer between 0 and 100.
- detectedSkills: list every technical/soft skill visible in the resume.
- missingSkills: list key skills required for the job role that are absent from the resume.
- recommendedResources: provide 3–5 real, useful learning resources for the missing skills.
- Output ONLY the JSON object. No preamble, no trailing text.
"""


class NLPEngine:
    """
    Uses the `ollama` Python package (synchronous) to perform deep resume analysis.
    The result is expected to be a structured JSON dict.
    """

    def __init__(self) -> None:
        self.model: str = settings.OLLAMA_MODEL

    async def analyze_resume(self, resume_text: str, job_role: str) -> dict:
        """
        Analyse a resume against a target job role.

        Args:
            resume_text: Raw text extracted from the uploaded PDF.
            job_role:    The target job role provided by the user.

        Returns:
            A dict containing matchScore, detectedSkills, missingSkills,
            and recommendedResources; or an error dict on failure.
        """
        # Truncate extremely long resumes to avoid model context limits.
        truncated_text = resume_text[:6000] if len(resume_text) > 6000 else resume_text

        prompt = _ANALYSIS_PROMPT_TEMPLATE.format(
            job_role=job_role,
            resume_text=truncated_text,
        )

        try:
            # ollama.chat is synchronous; run inside async context via executor if needed,
            # but for simplicity call it directly (Ollama is local and typically fast enough).
            response = ollama.chat(
                model=self.model,
                messages=[{"role": "user", "content": prompt}],
            )
            raw_text: str = response["message"]["content"]
            return self._parse_json(raw_text)

        except Exception as e:  # noqa: BLE001
            return {
                "error": f"NLP analysis failed: {e}",
                "matchScore": 0,
                "detectedSkills": [],
                "missingSkills": [],
                "recommendedResources": [],
            }

    # ------------------------------------------------------------------
    # Private helpers
    # ------------------------------------------------------------------

    def _parse_json(self, raw_text: str) -> dict:
        """
        Extract and parse the first JSON object found in `raw_text`.

        Args:
            raw_text: Raw model output that should contain a JSON block.

        Returns:
            Parsed dict, or an error dict with the raw text for debugging.
        """
        match = re.search(r"\{.*\}", raw_text, re.DOTALL)
        if not match:
            return {
                "error": "Model did not return valid JSON.",
                "raw": raw_text,
                "matchScore": 0,
                "detectedSkills": [],
                "missingSkills": [],
                "recommendedResources": [],
            }
        try:
            return json.loads(match.group())
        except json.JSONDecodeError as exc:
            return {
                "error": f"JSON decode error: {exc}",
                "raw": match.group(),
                "matchScore": 0,
                "detectedSkills": [],
                "missingSkills": [],
                "recommendedResources": [],
            }


# Module-level singleton.
nlp_engine = NLPEngine()
