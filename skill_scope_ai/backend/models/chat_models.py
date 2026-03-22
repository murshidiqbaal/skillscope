"""
models/chat_models.py
Pydantic request/response models for the chat endpoints.
"""

from typing import Optional
from pydantic import BaseModel


class ChatRequest(BaseModel):
    """Request body for POST /chat."""

    user_id: str
    message: str


class ChatMessage(BaseModel):
    """Represents a single message exchange stored in Supabase."""

    id: Optional[str] = None
    user_id: str
    message: str
    response: Optional[str] = None
    created_at: Optional[str] = None


class ChatResponse(BaseModel):
    """Response body for POST /chat."""

    response: str
