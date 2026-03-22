from supabase import create_client, Client
from core.config import settings

_JOB_ROLES_TABLE = "job_roles"
_RESOURCES_TABLE = "learning_resources"
_SKILLS_TABLE = "skills"


class JobRoleRepository:
    """
    Handles all database operations for job roles, skills, and learning resources.
    """

    def __init__(self) -> None:
        self.client: Client = create_client(settings.SUPABASE_URL, settings.SUPABASE_KEY)

    async def get_all_job_roles(self) -> list[dict]:
        """
        Retrieve all rows from the `job_roles` table.

        Returns:
            List of job role dicts.
        """
        response = self.client.table(_JOB_ROLES_TABLE).select("*").execute()
        return response.data or []

    async def get_resources_for_skills(self, skills: list[str]) -> list[dict]:
        """
        Retrieve learning resources whose `skill_name` matches any item in `skills`.

        Args:
            skills: A list of skill name strings to look up.

        Returns:
            List of matching learning resource dicts.
        """
        if not skills:
            return []
        response = (
            self.client.table(_RESOURCES_TABLE)
            .select("*")
            .in_("skill_name", skills)
            .execute()
        )
        return response.data or []

    async def get_skills_paginated(
        self,
        category: str | None = None,
        page: int = 0,
        page_size: int = 20,
    ) -> tuple[list[dict], int]:
        """
        Retrieve a paginated slice of the `skills` table, optionally filtered by category.

        Args:
            category:  Optional category filter.
            page:      Zero-based page index.
            page_size: Number of results per page.

        Returns:
            A tuple of (list of skill dicts, total count).
        """
        query = self.client.table(_SKILLS_TABLE).select("*", count="exact")
        if category:
            query = query.eq("category", category)

        start = page * page_size
        end = start + page_size - 1
        response = query.range(start, end).execute()
        total = response.count if response.count is not None else 0
        return response.data or [], total


# Module-level singleton used by resume and skills routers.
job_role_repository = JobRoleRepository()
