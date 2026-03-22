from fastapi import APIRouter, HTTPException
from models.chat_models import ChatRequest, ChatResponse, ChatMessage
from services.ollama_service import ollama_service
from repositories.chat_repository import chat_repository

router = APIRouter(tags=["Chat"])


@router.post("/chat", response_model=ChatResponse, status_code=200)
async def send_message(request: ChatRequest) -> ChatResponse:
    """
    Generate an AI response via Ollama, persist the exchange to Supabase,
    and return the assistant reply.
    """
    if not request.message.strip():
        raise HTTPException(status_code=400, detail="Message must not be empty.")

    try:
        # 1. Generate AI response first.
        ai_reply = await ollama_service.generate_response(request.message)

        # 2. Persist the entire exchange (user message + AI response).
        await chat_repository.save_message(
            user_id=request.user_id,
            message=request.message,
            response=ai_reply,
        )

        return ChatResponse(response=ai_reply)

    except Exception as exc:
        print(f"Chat error: {exc}")
        raise HTTPException(
            status_code=500, detail=f"Error processing chat message: {str(exc)}"
        )


@router.get(
    "/chat/history/{user_id}",
    response_model=list[ChatMessage],
    status_code=200,
)
async def get_chat_history(user_id: str) -> list[ChatMessage]:
    """
    Retrieve the full conversation history for a given user.
    """
    try:
        rows = await chat_repository.get_history(user_id=user_id)
        return [ChatMessage(**row) for row in rows]
    except Exception as exc:
        print(f"History error: {exc}")
        raise HTTPException(
            status_code=500, detail=f"Error fetching chat history: {str(exc)}"
        )
