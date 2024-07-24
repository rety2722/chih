from fastapi.testclient import TestClient

from app.core.config import settings
# from app.main import app

# client = TestClient(app)


def test_signup(client: TestClient) -> None:
    responce = client.post(
        f"{settings.API_V1_STR}/auth/signup",
        json={
            "email": "john@example.com",
            "password": "123456",
            "full_name": "John John",
        },
    )
    assert responce.status_code == 200
