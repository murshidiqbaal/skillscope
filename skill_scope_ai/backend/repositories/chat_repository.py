from supabase import create_client, Client
from core.config import settings

_TABLE = "chat_messages"


class ChatRepository:
    """
    Handles all database operations for chat messages.
    The Supabase client is initialised once per instance (dependency-injected singleton).
    """

    def __init__(self) -> None:
        self.client: Client = create_client(settings.SUPABASE_URL, settings.SUPABASE_KEY)

    async def save_message(self, user_id: str, message: str, response: str) -> dict:
        """
        Insert a new chat exchange into Supabase.

        Args:
            user_id:  The authenticated user's ID.
            message:  The user's input message.
            response: The AI assistant's response.

        Returns:
            The inserted row as a dict.
        """
        payload = {
            "user_id": user_id,
            "message": message,
            "response": response
        }
        try:
            result = self.client.table(_TABLE).insert(payload).execute()
            data = result.data
            return data[0] if data else {}
        except Exception as e:
            print(f"Error saving to Supabase: {e}")
            raise

    async def get_history(self, user_id: str) -> list[dict]:
        """
        Fetch conversation history for a given user ordered by creation time (ASC).

        Args:
            user_id: The authenticated user's ID.

        Returns:
            List of message dicts sorted oldest-first.
        """
        try:
            result = (
                self.client.table(_TABLE)
                .select("*")
                .eq("user_id", user_id)
                .order("created_at", desc=False)
                .execute()
            )
            return result.data or []
        except Exception as e:
            print(f"Error fetching from Supabase: {e}")
            return []


# Module-level singleton used by the chat router.
chat_repository = ChatRepository()
