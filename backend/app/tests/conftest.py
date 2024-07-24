from collections.abc import Generator

import pytest
from fastapi.testclient import TestClient
from sqlalchemy import delete
from sqlalchemy.orm import Session

from app import models
from app.core.config import settings
from app.core.db import SessionLocal
from app.main import app

from .utils.user import authentication_token_from_email


@pytest.fixture(scope="session", autouse=True)
def db() -> Generator[Session, None, None]:
    db = SessionLocal()
    try:
        yield db
        db.execute(delete(models.User))
        db.execute(delete(models.Event))
        db.commit()
    finally:
        db.close()


@pytest.fixture(scope="module")
def client() -> Generator[TestClient, None, None]:
    with TestClient(app) as c:
        yield c


@pytest.fixture(scope="module")
def normal_user_token_headers(client: TestClient, db: Session) -> dict[str, str]:
    return authentication_token_from_email(
        client=client, email=settings.EMAIL_TEST_USER, db=db
    )
