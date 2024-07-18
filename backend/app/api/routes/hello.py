"""
Заглушка для тестовых запросов
"""

from fastapi import APIRouter, HTTPException
from sqlmodel import Session

from app.core.db import engine
from app.crud import create_user, get_user_by_email
from app.models import User, UserCreate

router = APIRouter()


@router.get("/")
def root():
    return {"Чих": "Пых"}


@router.post("/")
def new_user(user_in: UserCreate) -> User:
    with Session(engine) as session:
        user = get_user_by_email(session=session, email=user_in.email)
        if user:
            raise HTTPException(
                status_code=400,
                detail="The user with this email already exists in the system.",
            )

        user = create_user(session=session, user_create=user_in)
        return user
