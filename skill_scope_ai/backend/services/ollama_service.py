import httpx
from core.config import settings

_SYSTEM_PROMPT = (
    "You are SkillScope AI, a helpful career assistant.\n\n"
    "You help users:\n"
    "• understand technology skills\n"
    "• choose career paths\n"
    "• learn software development skills\n"
    "• understand job requirements\n\n"
    "Provide clear, concise answers."
)


class OllamaService:
    """Handles all communication with the local Ollama inference server."""

    def __init__(self) -> None:
        self.base_url = f"{settings.OLLAMA_BASE_URL}/api/generate"
        self.model = settings.OLLAMA_MODEL

    async def generate_response(self, prompt: str) -> str:
        full_prompt = f"{_SYSTEM_PROMPT}\n\nUser: {prompt}\nAssistant:"

        payload = {
            "model": self.model,
            "prompt": full_prompt,
            "stream": False,
        }

        try:
            async with httpx.AsyncClient(timeout=90.0) as client:
                response = await client.post(self.base_url, json=payload)
                response.raise_for_status()
                data = response.json()
                return data.get("response", "No response from model.")

        except httpx.HTTPError as e:
            raise Exception(f"Ollama API error: {e}")
        except Exception as e:
            raise Exception(f"Unexpected error in OllamaService: {e}")


ollama_service = OllamaService()