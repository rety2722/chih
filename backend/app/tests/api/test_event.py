import random
from datetime import UTC, datetime

from fastapi.testclient import TestClient

from app.core.config import settings

from ..utils.utils import random_lower_string


def test_create_event(client: TestClient, normal_user_token_headers: dict[str, str]):
    payload = {
        "title": random_lower_string(),
        "description": random_lower_string() * 3,
        "latitude": random.randint(-90, 90),
        "longitude": random.randint(-180, 180),
        "time": datetime.now(UTC).isoformat(),
    }

    r = client.post(
        f"{settings.API_V1_STR}/event/create",
        headers=normal_user_token_headers,
        json=payload,
    )
    assert r.status_code == 200
    response = r.json()
    assert "id" in response
    r = client.get(f"{settings.API_V1_STR}/event/{response["id"]}")
    assert r.status_code == 200
