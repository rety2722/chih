"""
Заглушка для тестовых запросов
"""

from fastapi import APIRouter
from sqlmodel import Session
from app.database.db import engine

from app.database.models.user import User

router = APIRouter()


@router.get("/")
async def root():
    return {"Чих": "Пых"}


@router.post("/")
async def create_user(user: User):
    with Session(engine) as session:
        session.add(user)
        session.commit()
        session.refresh(user)
        return user
