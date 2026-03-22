import os
from typing import List
from pydantic_settings import BaseSettings, SettingsConfigDict

# Get the directory where config.py is located
current_dir = os.path.dirname(os.path.abspath(__file__))
# Get the backend directory (one level up from core)
backend_dir = os.path.dirname(current_dir)
# Handle both root and backend directory as CWD
env_path = os.path.join(backend_dir, ".env")

class Settings(BaseSettings):

    SUPABASE_URL: str | None = None
    SUPABASE_KEY: str | None = None

    APP_NAME: str = "SkillScope AI Backend"
    DEBUG: bool = False
    ALLOWED_HOSTS: List[str] = ["*"]

    OLLAMA_BASE_URL: str = "http://localhost:11434"
    OLLAMA_MODEL: str = "phi3"

    model_config = SettingsConfigDict(env_file=env_path, extra="ignore")


settings = Settings()